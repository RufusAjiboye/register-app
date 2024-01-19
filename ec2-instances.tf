resource "aws_instance" "appnode1" {
  ami                         = var.ubuntu_ami
  instance_type               = var.ec2_instance_type
  key_name                    = var.ec2_key_name
  subnet_id                   = aws_subnet.subnet_public1.id
  vpc_security_group_ids      = [aws_security_group.cicd_workflow.id]
  associate_public_ip_address = true

  tags = {
    Name = "Jenkins-Master"
  }
}

resource "aws_instance" "appnode3" {
  ami                         = var.ubuntu_ami
  instance_type               = var.ec2_instance_type
  key_name                    = var.ec2_key_name
  subnet_id                   = aws_subnet.subnet_public1.id
  vpc_security_group_ids      = [aws_security_group.cicd_workflow.id]
  associate_public_ip_address = true

  tags = {
    Name = "SonarQube"
  }
}

resource "aws_instance" "appnode2" {
  ami                         = var.ubuntu_ami
  instance_type               = var.ec2_instance_type
  key_name                    = var.ec2_key_name
  subnet_id                   = aws_subnet.subnet_public1.id
  vpc_security_group_ids      = [aws_security_group.cicd_workflow.id]
  associate_public_ip_address = true

  tags = {
    Name = "BootStrap_Servers"
  }
}