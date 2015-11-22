#
# Cookbook Name:: xmo
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'chef-client::service'
include_recipe 'yum'
include_recipe 'yum-epel'

package 'nginx'

service 'nginx' do
  action [:enable, :start]
end

user 'tomcat' do
  supports :manage_home => true
  home '/home/tomcat'
  shell '/bin/bash'
end

directory '/home/tomcat/.ssh' do
  recursive true
  owner 'tomcat'
  group 'tomcat'
end



include_recipe 'java'
execute "Set the java home directory owner and group permissions" do
	command "chown -R tomcat.tomcat #{node[:java][:java_home]}/"
end


include_recipe 'xmo::tomcat-setup'
include_recipe 'xmo::tomcat'
