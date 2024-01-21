resource "aws_security_group" "default" {
  name        = "default-${var.vpc_name}"
  description = "default group for ${var.vpc_name}"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
      from_port       = 0
      to_port         = 65535
      protocol        = "tcp"
      cidr_blocks     = ["14.19.59.178/32"]
      description     = "Cavas"
  }

  #    ingress {
  #      from_port   = 3022 # From Teleport ssh
  #      to_port     = 3024
  #      protocol    = "tcp"
  #      cidr_blocks = flatten([module.ips.aws_cidr_sacu_cnnorth1, module.ips.aws_cidr_sare_cnnorth1])
  #      description = "Internal ports from teleport proxy,auth."
  #    }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "External outbound https port to call datadog, apt"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "External outbound http port to call apt"
  }
}