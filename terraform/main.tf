terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "${var.region}"
}

resource "aws_key_pair" "aws-ec2-dev-key" {
  key_name = "aws-ec2-${var.username}-dev-key"
  public_key = "${var.public_key}"
}


data "template_file" "bolt_install_config" {
  template = file("./templates/bolt-install.yml.tpl")
}

resource "aws_instance" "bolt-jumpbox" {
  ami           = "ami-083f68207d3376798"
  instance_type = "t2.large"
  key_name               = aws_key_pair.aws-ec2-dev-key.id
  vpc_security_group_ids = [module.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc]
  user_data              = data.template_file.bolt_install_config.rendered
  iam_instance_profile   = "SSMInstanceProfile"

  connection {
  type = "ssh"
  user = "ubuntu"
  private_key = file(pathexpand("~/.ssh/dev-key"))
  host        = self.public_ip
  agent       = false
  }

#Need to add provisoner for github key access.
  provisioner "file" {
  source = "./files/inventory.yaml"
  destination = "/home/ubuntu/inventory.yaml"
  }

  provisioner "file" {
  source = "./files/params.json"
  destination = "/home/ubuntu/params.json"
  }

  provisioner "file" {
  source = "${var.local_private_key_path}"
  destination = "/home/ubuntu/.ssh/dev-key"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chown 600 /home/ubuntu/.ssh/dev-key"
    ]
  }  

  tags = {
    Name = "${var.username}-bolt-jumpbox"
    department       = var.department
    project          = var.project
    termination_date = var.termination_date
  }
}

resource "aws_instance" "pe-node" {
  ami           = "ami-083f68207d3376798"
  instance_type = "t2.large"
  key_name               = aws_key_pair.aws-ec2-dev-key.id
  vpc_security_group_ids = [module.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc]
  iam_instance_profile   = "SSMInstanceProfile"

  connection {
  type = "ssh"
  user = "ubuntu"
  private_key = file(pathexpand("~/.ssh/dev-key"))
  host        = self.public_ip
  agent       = false
  }


  provisioner "file" {
  source = "${var.local_private_key_path}"
  destination = "/home/ubuntu/.ssh/dev-key"
  }

  tags = {
    Name = "${var.username}pe-node"
    department       = var.department
    project          = var.project
    termination_date = var.termination_date
  }
}

resource "aws_instance" "pe-minion-node1" {
  ami           = "ami-083f68207d3376798"
  instance_type = "t2.large"
  key_name               = aws_key_pair.aws-ec2-dev-key.id
  vpc_security_group_ids = [module.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc]
  iam_instance_profile   = "SSMInstanceProfile"

  connection {
  type = "ssh"
  user = "ubuntu"
  private_key = file(pathexpand("~/.ssh/dev-key"))
  host        = self.public_ip
  agent       = false
  }


  provisioner "file" {
  source = "${var.local_private_key_path}"
  destination = "/home/ubuntu/.ssh/dev-key"
  }

  tags = {
    Name = "${var.username}-pe-minion-node1"
    department       = var.department
    project          = var.project
    termination_date = var.termination_date
  }
}

data "template_file" "cd4pe_install_config" {
  template = file("./templates/cd4pe-install.yml.tpl")
}

resource "aws_instance" "cd4pe-primary-node" {
  ami           = "ami-083f68207d3376798"
  instance_type = "c5a.4xlarge"
  key_name               = aws_key_pair.aws-ec2-dev-key.id
  vpc_security_group_ids = [module.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc]
  user_data              = data.template_file.cd4pe_install_config.rendered
  iam_instance_profile   = "SSMInstanceProfile"

  root_block_device {
    volume_type = "gp2"
    volume_size = "100"
  }

  tags = {
    Name = "${var.username}-cd4pe-primary-node"
    department       = var.department
    project          = var.project
    termination_date = var.termination_date
  }
}

resource "aws_route53_zone" "aws-tsedemos-com" {
  name = "${var.username}-aws.tsedemos.com"

  vpc {
    vpc_id = data.aws_vpc.us_west_1_default_vpc.id
  }
}

resource "aws_route53_record" "pe-node" {
  zone_id = aws_route53_zone.aws-tsedemos-com.id
  name = "pe-node.${var.initials}"
  type = "A"
  ttl = "300"
  records = [aws_instance.pe-node.private_ip]
}

resource "aws_route53_record" "bolt-jumpbox" {
  zone_id = aws_route53_zone.aws-tsedemos-com.id
  name = "bolt-jumpbox.${var.initials}"
  type = "A"
  ttl = "300"
  records = [aws_instance.bolt-jumpbox.private_ip]
}

resource "aws_route53_record" "cd4pe-primary-node" {
  zone_id = aws_route53_zone.aws-tsedemos-com.id
  name = "cd4pe-primary-node.${var.initials}"
  type = "A"
  ttl = "300"
  records = [aws_instance.cd4pe-primary-node.private_ip]
}

data "aws_vpc" "us_west_1_default_vpc" {
  id = var.vpc-id
}

module "comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc" {
  source = "./security-group"
  home_ip_address = [var.home_ip_address]
}

output "jumpbox_public_ip" {
  value = aws_instance.bolt-jumpbox.public_ip
}

output "cd4pe_primary_public_ip" {
  value = aws_instance.cd4pe-primary-node.public_ip
}

output "pe_public_ip" {
  value = aws_instance.pe-node.public_ip
}

output "jumpbox_private_ip" {
  value = aws_instance.bolt-jumpbox.private_ip
}

output "cd4pe_primary_private_ip" {
  value = aws_instance.cd4pe-primary-node.private_ip
}

output "pe__privateip" {
  value = aws_instance.pe-node.private_ip
}

data "template_file" "cluster2_bolt_install_config" {
  template = file("./templates/bolt-install.yml.tpl")
}

resource "aws_instance" "cluster2-bolt-jumpbox" {
  ami           = "ami-083f68207d3376798"
  instance_type = "t2.large"
  key_name               = aws_key_pair.aws-ec2-dev-key.id
  vpc_security_group_ids = [module.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc]
  user_data              = data.template_file.bolt_install_config.rendered
  iam_instance_profile   = "SSMInstanceProfile"

  connection {
  type = "ssh"
  user = "ubuntu"
  private_key = file(pathexpand("~/.ssh/dev-key"))
  host        = self.public_ip
  agent       = false
  }


  provisioner "file" {
  source = "./files/inventory.yaml"
  destination = "/home/ubuntu/inventory.yaml"
  }

  provisioner "file" {
  source = "./files/params.json"
  destination = "/home/ubuntu/params.json"
  }

  provisioner "file" {
  source = "${var.local_private_key_path}"
  destination = "/home/ubuntu/.ssh/dev-key"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chown 600 /home/ubuntu/.ssh/dev-key"
    ]
  }  

  tags = {
    Name = "${var.username}-cluster2-bolt-jumpbox"
    department       = var.department
    project          = var.project
    termination_date = var.termination_date
  }
}

resource "aws_instance" "cluster2-pe-node" {
  ami           = "ami-083f68207d3376798"
  instance_type = "t2.large"
  key_name               = aws_key_pair.aws-ec2-dev-key.id
  vpc_security_group_ids = [module.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc]
  iam_instance_profile   = "SSMInstanceProfile"

  connection {
  type = "ssh"
  user = "ubuntu"
  private_key = file(pathexpand("~/.ssh/dev-key"))
  host        = self.public_ip
  agent       = false
  }


  provisioner "file" {
  source = "${var.local_private_key_path}"
  destination = "/home/ubuntu/.ssh/dev-key"
  }

  tags = {
    Name = "cluster2-${var.username}-pe-node"
    department       = var.department
    project          = var.project
    termination_date = var.termination_date
  }
}

resource "aws_instance" "cluster2-pe-minion-node1" {
  ami           = "ami-083f68207d3376798"
  instance_type = "t2.large"
  key_name               = aws_key_pair.aws-ec2-dev-key.id
  vpc_security_group_ids = [module.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc]
  iam_instance_profile   = "SSMInstanceProfile"

  connection {
  type = "ssh"
  user = "ubuntu"
  private_key = file(pathexpand("~/.ssh/dev-key"))
  host        = self.public_ip
  agent       = false
  }


  provisioner "file" {
  source = "${var.local_private_key_path}"
  destination = "/home/ubuntu/.ssh/dev-key"
  }

  tags = {
    Name = "cluster2-${var.username}-pe-minion-node1"
    department       = var.department
    project          = var.project
    termination_date = var.termination_date
  }
}

data "template_file" "cluster2_cd4pe_install_config" {
  template = file("./templates/cd4pe-install.yml.tpl")
}

resource "aws_instance" "cluster2-cd4pe-primary-node" {
  ami           = "ami-083f68207d3376798"
  instance_type = "c5a.4xlarge"
  key_name               = aws_key_pair.aws-ec2-dev-key.id
  vpc_security_group_ids = [module.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc]
  user_data              = data.template_file.cd4pe_install_config.rendered
  iam_instance_profile   = "SSMInstanceProfile"

  root_block_device {
    volume_type = "gp2"
    volume_size = "100"
  }

  tags = {
    Name = "cluster2-${var.username}-cd4pe-primary-node"
    department       = var.department
    project          = var.project
    termination_date = var.termination_date
  }
}

resource "aws_route53_record" "cluster2-pe-node" {
  zone_id = aws_route53_zone.aws-tsedemos-com.id
  name = "cluster2-${var.username}-pe-node"
  type = "A"
  ttl = "300"
  records = [aws_instance.cluster2-pe-node.private_ip]
}

resource "aws_route53_record" "cluster2-bolt-jumpbox" {
  zone_id = aws_route53_zone.aws-tsedemos-com.id
  name = "cluster2-${var.username}-bolt-jumpbox"
  type = "A"
  ttl = "300"
  records = [aws_instance.cluster2-bolt-jumpbox.private_ip]
}

resource "aws_route53_record" "cluster2-cd4pe-primary-node" {
  zone_id = aws_route53_zone.aws-tsedemos-com.id
  name = "cluster2-${var.username}-cd4pe-primary-node"
  type = "A"
  ttl = "300"
  records = [aws_instance.cluster2-cd4pe-primary-node.private_ip]
}


resource "aws_iam_user" "velero-s3-bucket-user" {
  name = "${var.username}-velero-s3-bucket-user"
}

resource "aws_iam_user_policy" "velero-s3-bucket-user-policy" {
  user = aws_iam_user.velero-s3-bucket-user.name
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::${var.username}-puppet-dev-bucket/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.username}-puppet-dev-bucket"
            ]
        }
    ]
  })
}
resource "aws_iam_access_key" "velero-s3-bucket-user-access-key"{
  user = aws_iam_user.velero-s3-bucket-user.name
} 
resource "aws_instance" "cluster3-cd4pe-primary-node" {
  ami           = "ami-083f68207d3376798"
  instance_type = "c5a.4xlarge"
  key_name               = aws_key_pair.aws-ec2-dev-key.id
  vpc_security_group_ids = [module.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc]
  iam_instance_profile   = "SSMInstanceProfile"

  root_block_device {
    volume_type = "gp2"
    volume_size = "100"
  }

  tags = {
    Name = "cluster3-${var.username}-cd4pe-primary-node"
    department       = var.department
    project          = var.project
    termination_date = var.termination_date
  }
}

resource "aws_route53_record" "cluster3-cd4pe-primary-node" {
  zone_id = aws_route53_zone.aws-tsedemos-com.id
  name = "cluster3-${var.username}-cd4pe-primary-node"
  type = "A"
  ttl = "300"
  records = [aws_instance.cluster3-cd4pe-primary-node.private_ip]
}


output "cluster2_jumpbox_public_ip" {
  value = aws_instance.cluster2-bolt-jumpbox.public_ip
}

output "cluster2_cd4pe_primary_public_ip" {
  value = aws_instance.cluster2-cd4pe-primary-node.public_ip
}

output "cluster2_pe_public_ip" {
  value = aws_instance.cluster2-pe-node.public_ip
}

output "cluster2_jumpbox_private_ip" {
  value = aws_instance.cluster2-bolt-jumpbox.private_ip
}

output "cluster2_cd4pe_primary_private_ip" {
  value = aws_instance.cluster2-cd4pe-primary-node.private_ip
}

output "cluster2_pe__privateip" {
  value = aws_instance.cluster2-pe-node.private_ip
}

output "velero-s3-bucket-user-secret-key" {
  value = aws_iam_access_key.velero-s3-bucket-user-access-key.encrypted_secret
}