provider "aws" {
  profile = "default"
  region  = "${var.region}"
}

data "aws_vpc" "us_west_1_default_vpc" {
  id = "${var.vpc-id}"
}

resource "aws_security_group" "comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc" {
  name        = "comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc"
  description = "Allow all of the ports needed for CD4PE,PE, and Bolt test install"
  vpc_id      = data.aws_vpc.us_west_1_default_vpc.id

  ingress {
    description      = "ssh from home"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }

  
  ingress {
    description      = "HTTPS from home"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }

  ingress {
    description      = "HTTP from Home"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"    
  }

  ingress {
    description      = "8140 from Home"
    from_port        = 8140
    to_port          = 8140
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}" 
  }

  ingress {
    description      = "8142 from Home"
    from_port        = 8142
    to_port          = 8142
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }

  ingress {
    description      = "8800 from Home"
    from_port        = 8800
    to_port          = 8800
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }

  ingress {
    description      = "8080 from Home"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
  }

  ingress {
    description      = "6443 from Home"
    from_port        = 6443
    to_port          = 6443
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }

  ingress {
    description      = "8081 from Home"
    from_port        = 8081
    to_port          = 8081
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }

  ingress {
    description      = "4433 from Home"
    from_port        = 4433
    to_port          = 4433
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }

  ingress {
    description      = "8140 from Home"
    from_port        = 8140
    to_port          = 8140
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }

  ingress {
    description      = "8170 from Home"
    from_port        = 8170
    to_port          = 8170
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }

  ingress {
    description      = "8143 from Home"
    from_port        = 8143
    to_port          = 8143
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }

  ingress {
    description      = "8000 from Anywhere"
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "9001 from Home"
    from_port        = 9001
    to_port          = 9001
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }

  ingress {
    description      = "2379 from Home"
    from_port        = 2379
    to_port          = 2379
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }
  ingress {
    description      = "2380 from Home"
    from_port        = 2380
    to_port          = 2380
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }
  ingress {
    description      = "6783 from Home"
    from_port        = 6783
    to_port          = 6783
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }
  ingress {
    description      = "6783 from Home"
    from_port        = 6783
    to_port          = 6783
    protocol         = "udp"
    cidr_blocks      = "${var.home_ip_address}"
  }
  ingress {
    description      = "6784 from Home"
    from_port        = 6784
    to_port          = 6784
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }
  ingress {
    description      = "1025 from Home"
    from_port        = 1025
    to_port          = 1025
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }
  ingress {
    description      = "10250 from Home"
    from_port        = 10250
    to_port          = 10250
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }
  ingress {
    description      = "30303 from Home"
    from_port        = 30303
    to_port          = 30303
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }

  ingress {
    description      = "5432 from Home"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }

  ingress {
    description      = "3389 from Home"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = "${var.home_ip_address}"
  }

  

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }

  ingress {
    description      = "8140 from VPC"
    from_port        = 8140
    to_port          = 8140
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }

  ingress {
    description      = "8142 from VPC"
    from_port        = 8142
    to_port          = 8142
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }

  ingress {
    description      = "8800 from VPC"
    from_port        = 8800
    to_port          = 8800
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "8080 from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }

  ingress {
    description      = "6443 from VPC"
    from_port        = 6443
    to_port          = 6443
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }

  ingress {
    description      = "8081 from VPC"
    from_port        = 8081
    to_port          = 8081
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }

  ingress {
    description      = "8081 from VPC"
    from_port        = 8081
    to_port          = 8081
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }

  ingress {
    description      = "4433 from VPC"
    from_port        = 4433
    to_port          = 4433
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }

  ingress {
    description      = "8140 from VPC"
    from_port        = 8140
    to_port          = 8140
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }

  ingress {
    description      = "8170 from VPC"
    from_port        = 8170
    to_port          = 8170
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }

  ingress {
    description      = "8143 from VPC"
    from_port        = 8143
    to_port          = 8143
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }

  ingress {
    description      = "9001 from VPC"
    from_port        = 9001
    to_port          = 9001
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "2379 from VPC"
    from_port        = 2379
    to_port          = 2379
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "2380 from VPC"
    from_port        = 2380
    to_port          = 2380
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "6783 from VPC"
    from_port        = 6783
    to_port          = 6783
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "6783 from VPC"
    from_port        = 6783
    to_port          = 6783
    protocol         = "udp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "6784 from VPC"
    from_port        = 6784
    to_port          = 6784
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "1025 from VPC"
    from_port        = 1025
    to_port          = 1025
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "10250 from VPC"
    from_port        = 10250
    to_port          = 10250
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "5432 from VPC"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "30303 from VPC"
    from_port        = 30303
    to_port          = 30303
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "2381 from VPC"
    from_port        = 2381
    to_port          = 2381
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "6781 from VPC"
    from_port        = 6781
    to_port          = 6781
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "6782 from VPC"
    from_port        = 6782
    to_port          = 6782
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "10248 from VPC"
    from_port        = 10248
    to_port          = 10248
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }

  ingress {
    description      = "10249 from VPC"
    from_port        = 10249
    to_port          = 10249
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "9100 from VPC"
    from_port        = 9100
    to_port          = 9100
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "10257 from VPC"
    from_port        = 10257
    to_port          = 10257
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "10259 from VPC"
    from_port        = 10259
    to_port          = 10259
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }
  ingress {
    description      = "3389 from VPC"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc"
  }
}

output "comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc" {
    value = aws_security_group.comprehensive_ports_for_pe_bolt_cd4pe_home_and_vpc.id
}