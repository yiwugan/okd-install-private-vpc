# need to match your existing region
aws_region  = "ca-central-1"

# need to match existing vpc cidr
vpc_cidr    = "10.0.0.0/16"

# public subnet cidr to host jumpbox instance
jumpbox_cidr = "10.0.0.0/20" 

# jumpbox instance type, any 2 cpu 4G memory type will be fine
instance_type = "m5.large"

# name of key pair to be created for jumpbox instance
key_pair_name = "jumpbox-keypair"

# local file name of jumpbox private key
local_key_file_name = "./jumpbox-key.pem"

# amazon2 linux ami
instance_ami = "ami-0a590ca28046d073e"

