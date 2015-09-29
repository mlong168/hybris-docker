Role Name
=========

Install / setup a [Hybris](http://hybris.com) cluster

Requirements
------------

Ansible 1.6

Role Variables
--------------

hybris_enable: False # Set to true as needed
hybris_home_dir: Set the Hybris home  dir - eg /opt/hybris
hybris_temp_dir: "{{ hybris_home_dir }}/temp"
hybris_conf_file: "{{ hybris_home_dir }}/hybris/config/local.properties"
hybris_mysql_lib_dir: "{{ hybris_home_dir }}/hybris/bin/platform/lib/dbdriver"
hybris_build_dir: "{{ hybris_home_dir }}"
hybris_node_dir: "{{ hybris_home_dir }}/hybris/bin/custom/tourtrek/tourtrekstorefront/web/webroot/_ui"
hybris_git_user: Git Repo URL
hybris_connect_addr: 127.0.0.1
hybris_connect_port: 9001
hybris_s3_object: s3://hybris-commerce-suite-install/hybris-commerce-suite-5.3.0.3.zip
hybris_master_blaster: The master cluster server name/tag

# ssh known host 
ssh_known_hosts_command: "ssh-keyscan -H -T 10"
ssh_known_hosts_port_command: "ssh-keyscan -p 7999 -H -T 10"
ssh_known_hosts_file: "/etc/ssh/ssh_known_hosts"
ssh_known_hosts:
  - github.com
  - bitbucket.org

# Hybris init script options
daemon: "{{ hybris_home_dir }}/hybris/bin/platform/hybrisserver.sh"
pidfile: "/var/run/hybris.pid"
daemon_opts: "start"
service_name: hybris

# Hybris server config

hybris_tomcat_http_port: 8000
hybris_tomcat_ssl_port: 8001
hybris_cockpit_reports_vjdbc_port: 8000

hybris_tomcat_maxthreads: 200
hybris_tomcat_minsparethreads: 50
hybris_tomcat_maxidletime: 10000
hybris_tomcat_acceptcount: 100

hybris_build_development_mode: "true"
hybris_tomcat_development_mode: "true"

hybris_java_mem: "3G"
hybris_cache_main: 300000
hybris_tomcat_generaloptions: -Xmx${java.mem} -Xms${java.mem} -XX:PermSize=300M -XX:MaxPermSize=300M -Xss256K -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+CMSPermGenSweepingEnabled -XX:+CMSClassUnloadingEnabled -XX:+UseCMSInitiatingOccupancyOnly -XX:+CMSParallelRemarkEnabled -XX:+ParallelRefProcEnabled -XX:+CMSScavengeBeforeRemark -XX:+PrintGCTimeStamps -XX:+PrintGCDetails -Xloggc:"${HYBRIS_LOG_DIR}/tomcat/java_gc.log" -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dorg.tanukisoftware.wrapper.WrapperManager.mbean="true" -Djava.endorsed.dirs=../lib/endorsed -Dcatalina.base=%CATALINA_BASE% -Dcatalina.home=%CATALINA_HOME% -Dfile.encoding=UTF-8 -Dlog4j.configuration=log4j_init_tomcat.properties -Djava.util.logging.config.file=jdk_logging.properties -Djava.io.tmpdir="${HYBRIS_TEMP_DIR}" -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000


#put your additional java options here
hybris_tomcat_javaoptions: ""
hybris_tomcat_debugjavaoptions: "-Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,address=8002,suspend=n"

hybris_db_pool_maxactive: 90
hybris_db_pool_maxidle: 90

hybris_hmc_default_autologin: "false"
hybris_hmc_default_login: ""
hybris_hmc_default_password: "" 

hybris_cronjob_maxthreads: 50

hybris_hmc_debug_showjspcomments: "true"
hybris_hmc_developermode: "true"

# Database Options

hybris.db_url: 
hybris.db_driver: 
hybris.db_username: 
hybris.db_password: 
hybris.mysql_tabletype: 
hybris.mysql_allow_fractional_seconds: 
hybris.db_tableprefix: 
hybris.db_customsessionsql: 
hybris.mysql_optional_tabledefs: 


# Cluster Config

hybris.clustermode: 
hybris.cluster_id: 
hybris.cluster_maxid: 
hybris.cluster_broadcast_methods: 
hybris.cluster_broadcast_method_jgroups: 
hybris.cluster_broadcast_method_jgroups_tcp_bind_addr: 
hybris.cluster_broadcast_method_jgroups_tcp_bind_port: 
hybris.cluster_broadcast_method_jgroups_channel_name: 

# The session timeout (in seconds)_
# If you specify 0 or less, the session will never timeout
hybris_default_session_timeout: 1800

hybris_tourtrekstorefront_build_gulp: "true"


# DEV REST Logging:
hybris_ondemand_slf4jbridge_activated: "true"
hybris_hybris_rest_client_logging_enabled: "true"


Dependencies
------------

None

Example Playbook
----------------

with a hosts file containing 1 IP address under the region "maincoordinator" and N IP addresses under "node".

Servers use a private network IP on eth1 (change to eth0 is needed)

    - hosts: maincoordinator
      sudo: yes
      roles:
        - {
            role: hybris,
            hybris_coordinator_enable: True,
            hybris_coordinator_listen_addr: "{{ ansible_eth1.ipv4.address }}",
            hybris_daemon_enable: True,
            hybris_daemon_listen_addr: "{{ ansible_eth1.ipv4.address }}",
            hybris_daemon_connect_addr: "{{ ansible_eth1.ipv4.address }}",
            hybris_daemon_connect_port: 6000,
            tags: ['hybris']
          }


    - hosts: node
      sudo: yes
      roles:
        - {
            role: hybris,
            hybris_coordinator_enable: True,
            hybris_coordinator_listen_addr: "{{ ansible_eth1.ipv4.address }}",
            hybris_coordinator_connect_addr: "{{ hostvars[groups['maincoordinator'][0]]['ansible_eth1']['ipv4']['address'] }}",
            hybris_coordinator_connect_port: 6000,
            hybris_daemon_enable: True,
            hybris_daemon_listen_addr: "{{ ansible_eth1.ipv4.address }}",
            hybris_daemon_connect_addr: "{{ ansible_eth1.ipv4.address }}",
            tags: ['hybris']
          }

License
-------

MIT
