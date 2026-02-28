output "instance_public_ip" {
  value = aws_instance.dev_ec2.public_ip
}

output "vpc_id" {
  value = aws_vpc.dev_vpc.id
}