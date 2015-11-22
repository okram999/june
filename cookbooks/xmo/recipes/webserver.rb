require 'chef/provisioning/aws_driver'

with_machine_options :ssh_username => 'centos',
  :bootstrap_options => {
    :key_name => 'test2_aws',
    :image_id => 'ami-e46a7a85',
    :instance_type => 't2.micro',
    :user_data => 'xmo-dev', #this needs to change with the environment
    :security_group_ids => 'sg-2ba4ca4e', #This needs to change with environment.
##Added to test the options from the AWS Ruby SDK
    :availability_zone => "us-west-2b"

  }


#ENV1 = 'dev'

machine'xmo2-dev1.something.com' do
  chef_environment 'dev'  #this should read the bootstrap_options to get the data dynamically
  recipe 'xmo::default'
end

# machine'xmo2-dev2.something.com' do
#   chef_environment 'dev'
#   recipe 'xmo::default'
# end
