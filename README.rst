
This is an example of using 'terraform state mv' from 1 top level configuration to another.

The source configuration seems to want to recreate the 'test1' host instance after moving the
containing VPC and subnet.

./test1 is a top level configuration, with 2 modules, test_host and vpc.

./vpc is the target top level configuration where we want to migrate the ./test1/vpc/ module
configuration and state from the ./test1/ top level configuration.

Steps
=====

#. In ./test1
   ::
     tf init
     tf plan
     tf apply

#. 'tf state list' should show
   ::
     $ tf state list
     module.test_host.aws_ami.ubuntu
     module.test_host.aws_instance.test_host
     module.vpc.aws_subnet.main_vpc_subnet
     module.vpc.aws_vpc.main

#. Create an empty terraform.tfstate file in vpc/
   ::
     cp ../files/terraform.tfstate.empty terraform.tfstate

#. In ./test1/, move the vpc module resources
   ::
     tf state mv -state-out ../vpc/terraform.tfstate module.vpc.aws_subnet.main_vpc_subnet aws_subnet.main_vpc_subnet
     tf state mv -state-out ../vpc/terraform.tfstate module.vpc.aws_vpc.main aws_vpc.main

#. Fix ./vpc/
   ::
     $ cd vpc
     $ rm -f main.tf outputs.tf
     $ ln -s z.remote/*.tf .
     
#. Verify that ./vpc top level configurations with the migrated state show no changes in plan
   ::
     $ tf init
     $ tf plan

#. In ./test1/, init and plan
   ::
     $ tf init
     $ tf plan

   At this point you see that terraform (0.9.11) wants to recreate the test_host instance due to
   subnet change.  However, the subnet already exists, and is found in the ../vpc/terraform.tfstate
   file as expected.
   
   The output I get is
   ::

      -/+ module.test_host.aws_instance.test_host (new resource required)
      id:                           "i-0729a1374eee8a684" => <computed>
      ami:                          "ami-969ab1f6" => "ami-969ab1f6"
      associate_public_ip_address:  "false" => <computed>
      availability_zone:            "us-west-1b" => <computed>
      ebs_block_device.#:           "0" => <computed>
      ephemeral_block_device.#:     "0" => <computed>
      instance_state:               "running" => <computed>
      instance_type:                "t2.micro" => "t2.micro"
      ipv6_address_count:           "" => <computed>
      ipv6_addresses.#:             "0" => <computed>
      key_name:                     "" => <computed>
      network_interface.#:          "0" => <computed>
      network_interface_id:         "eni-0ea18c22" => <computed>
      placement_group:              "" => <computed>
      primary_network_interface_id: "eni-0ea18c22" => <computed>
      private_dns:                  "ip-10-0-0-28.us-west-1.compute.internal" => <computed>
      private_ip:                   "10.0.0.28" => <computed>
      public_dns:                   "" => <computed>
      public_ip:                    "" => <computed>
      root_block_device.#:          "1" => <computed>
      security_groups.#:            "0" => <computed>
      source_dest_check:            "true" => "true"
      subnet_id:                    "subnet-1f4fb978" => "${var.vpc_subnet_id}"
      tags.%:                       "2" => "2"
      tags.Environment:             "allan" => "allan"
      tags.Name:                    "test_host" => "test_host"
      tenancy:                      "default" => <computed>
      volume_tags.%:                "0" => <computed>
      vpc_security_group_ids.#:     "1" => <computed>

      Plan: 1 to add, 0 to change, 1 to destroy.
