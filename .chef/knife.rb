# See https://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "okram999"
client_key               "#{current_dir}/okram999.pem"
validation_client_name   "aws_dev-validator"
validation_key           "#{current_dir}/aws_dev-validator.pem"
chef_server_url          "https://api.chef.io/organizations/aws_dev"
cookbook_path            ["#{current_dir}/../cookbooks"]

#knife[:aws_access_key_id] = "aws_access_key_id"
#knife[:aws_secret_access_key] = "aws_secret_access_key"
#knife[:region] = "aws-region"

knife[:aws_ssh_key_id] = "test2_aws"
