name "dev"
description "The test environment"

override_attributes({
                      "dspring" => {"active_profile" => "dev",
                                    "jss_cert_location" => "/opt/mount1/certs/jssecacerts",
                                    "keystore_location" => "/opt/mount1/certs/xmoClientCerts.jks",
                                    "keystore_password" => "changeit"},
                      "privileged_users" => ["jenkins"],
                      "nginx" => {"server_name" => "xxxxxxxx.com"}
                    })
default_attributes({"zabbix" => {"agent" => {"servers" => ['somename.com'],
                                             "servers_active" => ['somename.com']
}},
                    "certs" => {"environment" => "pie1"}
                   })
