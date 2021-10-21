# Create a Null Resource and Provisioners
resource "null_resource" "name" {
  depends_on = [module.ec2_public,module.ec2_private]
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type     = "ssh"
    host     = aws_eip.bastion_eip.public_ip    
    user     = "ubuntu"
    password = ""
    private_key = file("private-key/iacdevops.pem")
  }  

## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source      = "private-key/iacdevops.pem"
    destination = "/tmp/iacdevops.pem"
  }

    provisioner "file" {
    source      = "private-key/vtb-node"
    destination = "/home/ubuntu/vtb-node"
  }

    provisioner "file" {
    source      = "private-key/pingservice"
    destination = "/home/ubuntu/pingservice"
  }

   provisioner "file" {
    source      = "${path.module}/node-install.sh"
    destination = "/home/ubuntu/node-install.sh"
  }

   provisioner "file" {
    source      = "${path.module}/app1-install.sh"
    destination = "/home/ubuntu/app1-install.sh"
  }
  
## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/iacdevops.pem",
      "sudo chmod 777 vtb-node",
      "sudo chmod 777 pingservice",
      "sudo chmod 777 node-install.sh",
      "sudo chmod 777 app1-install.sh",
      "sleep 20",
      "ssh-keyscan -H ${module.ec2_private.private_ip[0]} >> ~/.ssh/known_hosts",
      "ssh-keyscan -H ${module.ec2_private.private_ip[1]} >> ~/.ssh/known_hosts",
      "ssh-keyscan -H ${module.ec2_private.private_ip[2]} >> ~/.ssh/known_hosts",
      "scp -i /tmp/iacdevops.pem pingservice vtb-node node-install.sh app1-install.sh ubuntu@${module.ec2_private.private_ip[0]}:",
      "scp -i /tmp/iacdevops.pem pingservice vtb-node app1-install.sh ubuntu@${module.ec2_private.private_ip[1]}:",
      "scp -i /tmp/iacdevops.pem pingservice vtb-node app1-install.sh ubuntu@${module.ec2_private.private_ip[2]}:",
    ]
  }
}

resource "null_resource" "node1" {
  depends_on = [resource.null_resource.name]
  # Connection Block for Provisioners to connect to EC2 Instance
   connection {
      type        = "ssh"
      bastion_host = aws_eip.bastion_eip.public_ip 
      bastion_user = "ubuntu"
      bastion_private_key = file("private-key/iacdevops.pem")
      bastion_port = 22
      user        = "ubuntu"
      private_key = file("private-key/iacdevops.pem")
      host        = module.ec2_private.private_ip[0]
      port = 22
    }

 provisioner "file" {
    source      = "private-key/iacdevops.pem"
    destination = "/tmp/iacdevops.pem"
  }


## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
   provisioner "remote-exec" {
          inline = [
            "sudo chmod 400 /tmp/iacdevops.pem",
            "sudo ./app1-install.sh",
            "sudo ./node-install.sh",
            "ssh-keyscan -H ${module.ec2_private.private_ip[1]} >> ~/.ssh/known_hosts",
            "ssh-keyscan -H ${module.ec2_private.private_ip[2]} >> ~/.ssh/known_hosts",
            "sudo chmod 777 ./substrate-as/demo.log",
            "scp -i /tmp/iacdevops.pem /home/ubuntu/substrate-as/demo.log ubuntu@${module.ec2_private.private_ip[1]}:",
            "scp -i /tmp/iacdevops.pem /home/ubuntu/substrate-as/demo.log  ubuntu@${module.ec2_private.private_ip[2]}:",
          ]
      
      }
}

resource "null_resource" "node2" {
  depends_on = [resource.null_resource.name]
   triggers = {
    template = "${data.template_file.node_template.rendered}"
  }
  # Connection Block for Provisioners to connect to EC2 Instance
   connection {
      type        = "ssh"
      bastion_host = aws_eip.bastion_eip.public_ip 
      bastion_user = "ubuntu"
      bastion_private_key = file("private-key/iacdevops.pem")
      bastion_port = 22
      user        = "ubuntu"
      private_key = file("private-key/iacdevops.pem")
      host        = module.ec2_private.private_ip[1]
      port = 22
    }

 provisioner "file" {
    source      = "${data.template_file.node_template.rendered}"
    destination = "/home/ubuntu/node2-install.tpl"
  }

## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
   provisioner "remote-exec" {
          inline = [
            "sudo chmod 777 node2-install.tpl",
            "sudo ./app1-install.sh",
            "sudo ./node2-install.tpl"
          ]
      
      }
}

resource "null_resource" "node3" {
  depends_on = [resource.null_resource.name]
   triggers = {
    template = "${data.template_file.node_template.rendered}"
  }
  # Connection Block for Provisioners to connect to EC2 Instance
   connection {
      type        = "ssh"
      bastion_host = aws_eip.bastion_eip.public_ip 
      bastion_user = "ubuntu"
      bastion_private_key = file("private-key/iacdevops.pem")
      bastion_port = 22
      user        = "ubuntu"
      private_key = file("private-key/iacdevops.pem")
      host        = module.ec2_private.private_ip[2]
      port = 22
    }

provisioner "file" {
    source      = "${data.template_file.node_template.rendered}"
    destination = "/home/ubuntu/node2-install.tpl"
  }

## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
   provisioner "remote-exec" {
          inline = [
            "sudo chmod 777 node2-install.tpl",
            "sudo ./app1-install.sh",
            "sudo ./node2-install.tpl"
          ]
      
      }
}

data "template_file" "node_template" {
  template = "${file("${path.module}/node2-install.tpl")}"

  vars {
    node1_endpoint = "${module.ec2_private.private_ip[0]}"
  }
}
# Creation Time Provisioners - By default they are created during resource creations (terraform apply)
# Destory Time Provisioners - Will be executed during "terraform destroy" command (when = destroy)