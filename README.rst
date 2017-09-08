
This is an example of using 'terraform state mv' from 1 top level configuration to another.

The source configuration seems to want to recreate the 'test1' host instance after moving the
containing VPC and subnet.

./test1 is a top level configuration, with 2 modules, test_host and vpc.

./vpc is the target top level configuration where we want to migrate the ./test1/vpc/ module
configuration and state from the ./test1/ top level configuration.

Steps
=====

#. In ./test1/vpc::
     $ ln -sf z.local/*.tf .

#. In ./test1::
     tf init
     tf plan
     tf apply

#. 'tf state list' should show::
     $ tf state list
     module.test_host.aws_ami.ubuntu
     module.test_host.aws_instance.test_host
     module.vpc.aws_subnet.main_vpc_subnet
     module.vpc.aws_vpc.main

#. Create an empty terraform.tfstate file in vpc/::
     cp ../files/terraform.tfstate.empty terraform.tfstate

#. In ./test1/, move the vpc module resources::
     tf state mv -state-out ../vpc/terraform.tfstate module.vpc.aws_subnet.main_vpc_subnet aws_subnet.main_vpc_subnet
     tf state mv -state-out ../vpc/terraform.tfstate module.vpc.aws_vpc.main aws_vpc.main

#. Fix ./vpc/::
     $ cd vpc
     $ rm -f main.tf outputs.tf
     $ ln -s z.remote/*.tf .
     
#. Verify that ./vpc top level configurations with the migrated state show no changes in plan::
     $ tf init
     $ tf plan

#. In ./test1/, init and plan::
     $ tf init
     $ tf plan

   At this point you see that terraform (0.9.11) wants to recreate the test_host instance due to
   subnet change.  However, the subnet already exists, and is found in the ../vpc/terraform.tfstate
   file as expected.
   
