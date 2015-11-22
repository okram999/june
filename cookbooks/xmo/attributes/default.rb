default['java']['runtime_environment']['version'] = 'jre1.7.0_65'
override['java']['oracle']['accept_oracle_download_terms'] = true
override['java']['accept_license_agreement'] = true
override['java']['install_flavor'] = 'oracle'
override['java']['jdk_version'] = '7'
override['java']['java_home'] = '/opt/mount1/java'

default['base_dir'] = '/opt/mount1'
default['certificate_directory'] = '/opt/apps/ms/config/certs'
default['essential_dirs'] = ['wpconfig', 'certs']

default['ssh_key']['deployment'] = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC93HUxn+XntSmre0Kq1+tfCkzaACPYPdjY8kgad4nfv48mqnOMT225L+Y+o9I+7p8hyY8MlNfVTZ3hCHEnzfw10kSyoo8DeoQWAUdVufEepbPshFb9EfOYC46J4/E6HStcUdsLiyB1aPZ/QjsMwOq9mnbIgchVQq0M9+GEhNswGQFZYtBbCKxguqqjcH+4PTJ2us+IkQxFQaf55lLFTTQ7Yh5WpYI4YntzRUORzOPK/9NVAaNQPi8nd3AbJspMiV3ksf6EWcadqsWUuxUbWBVdZ46kcYg7SRGfuqm515aDZXW2vcCpE0fSMUTH4TBcXiMuSPhqAB9Jz9Qief+eAoq9 provisioner@provisionerssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC93HUxn+XntSmre0Kq1+tfCkzaACPYPdjY8kgad4nfv48mqnOMT225L+Y+o9I+7p8hyY8MlNfVTZ3hCHEnzfw10kSyoo8DeoQWAUdVufEepbPshFb9EfOYC46J4/E6HStcUdsLiyB1aPZ/QjsMwOq9mnbIgchVQq0M9+GEhNswGQFZYtBbCKxguqqjcH+4PTJ2us+IkQxFQaf55lLFTTQ7Yh5WpYI4YntzRUORzOPK/9NVAaNQPi8nd3AbJspMiV3ksf6EWcadqsWUuxUbWBVdZ46kcYg7SRGfuqm515aDZXW2vcCpE0fSMUTH4TBcXiMuSPhqAB9Jz9Qief+eAoq9 provisioner@provisioner' #authorized_keys for the jenkins user

default['tomcat']['version'] = '7.0.54'
default['tomcat']['log_dir'] = ::File.join(node[:base_dir],"tomcat-#{node[:tomcat][:version]}",'logs')
default['tomcat']['wp_config_home'] = ::File.join(node[:base_dir],'wpconfig')
default['tomcat']['minimum_memory'] = 1024
default['tomcat']['maximum_memory'] = 6144
default['tomcat']['certs_path'] = '/opt/mount1/certs'
default['tomcat']['app_log_dir'] = '/opt/mount1/tomcat/logs/application'
default['tomcat']['application'] = '123'

default['tomcat']['jmx']['port'] = 9192
default['tomcat']['jmx']['ssl'] = 'false'
default['tomcat']['jmx']['authentication'] = 'true'

default['tomcat']['jmx']['userpass'] = {'zabbix' => 'ZabbixPassword1!'}
default['appconfig']['driver'] = 'com.mysql.jdbc.Driver'
