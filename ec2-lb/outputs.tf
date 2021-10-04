output "lb_address" {
  value = aws_elb.web.dns_name
}

output "servers_address" {
  value = "aws_instance.web[count.index].private_ip"
}