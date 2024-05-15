# Define provider (AWS)
provider "aws" {
  region = "us-east-1" # Update with your desired region
}

# Define variables
variable "aws_region" {
  description = "AWS region where resources will be created"
  default     = "us-east-1" # Update with your desired region
}

variable "web_instance_type" {
  description = "Instance type for web tier"
  default     = "t2.micro" # Update with your desired instance type
}

variable "app_instance_type" {
  description = "Instance type for application tier"
  default     = "t2.micro" # Update with your desired instance type
}

variable "db_instance_type" {
  description = "Instance type for database tier"
  default     = "db.t2.micro" # Update with your desired instance type
}

# Create Security Groups
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Security group for web tier"
  
  // Define ingress rules (allow traffic)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Security group for application tier"
  
  // Allow incoming traffic from web tier
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Security group for database tier"
  
  // Allow incoming traffic only from application tier
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
}

# Create EC2 instances
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Update with desired AMI
  instance_type = var.web_instance_type
  security_groups = [aws_security_group.web_sg.name]
  
  // You may want to add additional configuration here, like userdata for web servers
}

resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0" # Update with desired AMI
  instance_type = var.app_instance_type
  security_groups = [aws_security_group.app_sg.name]
  
  // You may want to add additional configuration here, like userdata for application servers
}

# Create RDS instance
resource "aws_db_instance" "db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.db_instance_type
  name                 = "mydb"
  username             = "admin"
  password             = "admin123"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible  = false
  skip_final_snapshot  = true
  security_group_names = [aws_security_group.db_sg.name]
}

# Output the details
output "web_instance_ip" {
  value = aws_instance.web.public_ip
}

output "app_instance_ip" {
  value = aws_instance.app.public_ip
}

output "db_instance_endpoint" {
  value = aws_db_instance.db.endpoint
}
