#
# Cookbook Name:: nginx
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
