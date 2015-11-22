package 'nss' do
  action :upgrade
end

directory node[:base_dir] do
  owner 'root'
  group 'root'
  mode 00755
end

directory node[:certificate_directory] do
  owner 'tomcat'
  group 'tomcat'
  mode 00755
  recursive true
end

node[:essential_dirs].each do |dir|
  directory "#{node[:base_dir]}/#{dir}" do
    owner 'root'
    group 'root'
  end
end


user 'jenkins' do
  supports :manage_home => true
  comment "Jenkins deploy user"
  home "/home/jenkins"
  shell "/bin/bash"
end

directory '/home/jenkins/.ssh' do
  recursive true
  owner 'jenkins'
  group 'jenkins'
end

template '/home/jenkins/.ssh/authorized_keys' do
  source 'ssh_key.erb'
  mode 00644
  owner 'jenkins'
  group 'jenkins'
  variables(
    :key => node[:ssh_key][:deployment]
  )
end


template '/etc/sudoers' do
  source 'sudoers.erb'
  owner 'root'
  group 'root'
  mode 00440
  variables(
    :privileged_users => node[:privileged_users],
    :environment => node.chef_environment,
    :hostname => node.hostname
  )
end
