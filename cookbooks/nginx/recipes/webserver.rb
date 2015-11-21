require 'chef/provisioning/aws_driver'

with_machine_options :ssh_username => 'centos',
  :bootstrap_options => {
    :key_name => 'test2_aws',
    :image_id => 'ami-e46a7a85',
    :instance_type => 't2.micro',
    #:security_group_ids => 'your-security-group-id' #This has to be AWS Securitry Group ID(s).
  }


#ENV1 = 'dev'

machine'xmo2-dev1' do
  chef_environment 'dev'
  recipe 'nginx::default'
end

machine'xmo2-dev2' do
  chef_environment 'dev'
  recipe 'nginx::default'
end
