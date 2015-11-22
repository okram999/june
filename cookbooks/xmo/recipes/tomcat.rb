
ark "tomcat-#{node[:tomcat][:version]}" do
  url "http://archive.apache.org/dist/tomcat/tomcat-7/v#{node[:tomcat][:version]}/bin/apache-tomcat-#{node[:tomcat][:version]}.tar.gz"
  path "#{node[:base_dir]}"
  owner 'tomcat'
  group 'tomcat'
  action :put
end

link "#{node[:base_dir]}/tomcat" do
  to "#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}"
  owner 'tomcat'
  group 'tomcat'
end

directory "#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}/bin" do
  owner 'tomcat'
  group 'tomcat'
  recursive true
end

directory "#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}/conf" do
  owner 'tomcat'
  group 'tomcat'
  recursive true
end

# Removes the ROOT directory inside of webapps to make room for the custom WAR file for 123HP, but only if it's the default ROOT (contains tomcat default files)
directory "#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}/webapps/ROOT" do
  action :delete
  recursive true
  only_if { ::File.exists?("#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}/webapps/ROOT/tomcat.css") }
end

# Removes the docs directory inside of tomcat. No need to keep default tomcat apps
directory "#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}/webapps/docs" do
  action :delete
  recursive true
  only_if { ::File.exists?("#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}/webapps/docs/apr.html") }
end

# Removes the manager directory inside of tomcat. No need to keep default tomcat apps
directory "#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}/webapps/examples" do
  action :delete
  recursive true
  only_if { ::File.exists?("#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}/webapps/examples/index.html") }
end

# Removes the host-manager directory inside of tomcat. No need to keep default tomcat apps
directory "#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}/webapps/host-manager" do
  action :delete
  recursive true
  only_if { ::File.exists?("#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}/webapps/host-manager/manager.xml") }
end

# Removes the manager directory inside of tomcat. No need to keep default tomcat apps
directory "#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}/webapps/manager" do
  action :delete
  recursive true
  only_if { ::File.exists?("#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}/webapps/manager/status.xsd") }
end


template "#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}/bin/setenv.sh" do
  source 'setenv.sh.erb'
  mode 00755
  variables(
    :jss_cert_location => "#{node[:dspring][:jss_cert_location]}",
    :keystore_location => "#{node[:dspring][:keystore_location]}",
    :keystore_password => "#{node[:dspring][:keystore_password]}",
    :java_home => "#{node[:java][:java_home]}",
    :wp_config_home => node[:tomcat][:wp_config_home],
    :dspring_profile => node[:dspring][:active_profile],
    :min_mem => node[:tomcat][:minimum_memory],
    :max_mem => node[:tomcat][:maximum_memory],
    :log_location => node[:tomcat][:app_log_dir],
    :jmx_port => node[:tomcat][:jmx][:port],
    :jmx_ssl => node[:tomcat][:jmx][:ssl],
    :jmx_auth => node[:tomcat][:jmx][:authentication]
  )
end

credentials = Chef::EncryptedDataBagItem.load("#{node.chef_environment}", "#{node.chef_environment}")

template "#{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}/conf/tomcat-users.xml" do
  source 'tomcat-users.xml.erb'
  owner 'tomcat'
  group 'tomcat'
  variables(
    :tomcat_username => credentials['tomcat']['username'],
    :tomcat_password => credentials['tomcat']['password'],
    :tomcat_deploy_username => credentials['tomcat_deploy']['username'],
    :tomcat_deploy_password => credentials['tomcat_deploy']['password'],
  )
end

template "#{node[:base_dir]}/wpconfig/wp_config_datasource.properties" do
  source 'wp_config_datasource.properties.erb'
  owner 'tomcat'
  group 'tomcat'
  variables(
    :appconfig_user => credentials['app_config']['username'],
    :appconfig_pass => credentials['app_config']['password'],
    :appconfig_drvier => node[:appconfig][:driver],
    :appconfig_jdbc_url => credentials['app_config']['jdbc_url'],
    :wpconfig_user => credentials['wp_config']['username'],
    :wpconfig_pass => credentials['wp_config']['password'],
    :wpconfig_driver => node[:appconfig][:driver],
    :wpconfig_jdbc_url => credentials['wp_config']['jdbc_url'],
  )
end

directory node['tomcat']['app_log_dir'] do
  owner 'tomcat'
  group 'tomcat'
  recursive true
end

template "/etc/init.d/tomcat" do
  source 'tomcat_init.erb'
  mode 00755
  owner 'root'
  group 'root'
  variables(
    :tomcat_home => "#{node[:base_dir]}/tomcat",
  )
end

template '/opt/mount1/java/jre/lib/management/jmxremote.access' do
  source 'jmxremote.access.erb'
  mode 00600
  owner 'tomcat'
  group 'tomcat'
  variables(
    :jmx_user => credentials['zabbix_user']['username']
  )
  notifies :restart, "service[tomcat]", :delayed
end

template '/opt/mount1/java/jre/lib/management/jmxremote.password' do
  source 'jmxremote.password.erb'
  mode 00600
  owner 'tomcat'
  group 'tomcat'
  variables(
    :jmx_user => credentials['zabbix_user']['username'],
    :jmx_pass => credentials['zabbix_user']['password']
  )
  notifies :restart, "service[tomcat]", :delayed
end

execute 'Ensure tomcat permissions are set properly' do
  command "chown -R tomcat:tomcat #{node[:base_dir]}/tomcat-#{node[:tomcat][:version]}"
end

template "/etc/logrotate.d/tomcat_catalina_out" do
  source "logrotate.erb"
  mode 00600
  variables(:log_file => "#{node['tomcat']['log_dir']}/catalina.out",
            :log_occurance => 'daily',
            :files_to_keep => '10',
            :owner_mode => 'create 644 tomcat tomcat')
end

service "tomcat" do
  action :enable
end

execute "start tomcat" do
  command "service tomcat start"
end
