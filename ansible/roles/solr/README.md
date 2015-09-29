solr
========

Ansible role for installing and configuring Solr.

Requirements
------------

none

Role Variables
--------------


- **solr_action**: which action should be taken by the role. It can be _install_ (installs solr web application and its dependencies) or *install_core* (configure and regiter a new core at solr). Defaults to _install_
- **solr_version**: which solr version to use.  Defaults to _4.4.0_
- **solr_package**: solr package name as it is downloaded. Defaults to *'solr-{{solr_version}}.tgz'*
- **solr_installation_dir**: directory that solr.war will be copied to, and that will be used as solr.home. Defaults to *'~/solr'*
- **solr_download_dir**: path where the solr package will be downloaded at the control machine. Defaults to *'~/Downloads'*
- **solr_local_dir**: path where solr package will be unpackaged at the control machine. Defaults to *'{{solr_download_dir}}/solr-{{solr_version}}'*
- **solr_log_level**: level which solr will log. Defauls to *'INFO'*
- **solr_download_url**: from which url solr package will be downloaded . Defaults to *'https://archive.apache.org/dist/lucene/solr/{{solr_version}}/{{solr_package}}'*
- **solr_container**: web application container that solr.war will be deployed. Supports tomcat or jetty (embedded version distributed with solr) . Defaults to *'jetty'*
- **solr_port**: http port where solr will respond requests. Defaults to *8080*

####Core specific variables

- **solr_data_dir**: path that target core will use for is indexes. Defaults to *'{{solr_installation_dir}}/{{solr_core_name}}/data'*
- **solr_commit_soft_max_time**: 60000
- **solr_commit_soft_max_docs**: 100
- **solr_commit_soft_open_searcher**: "true"
- **solr_commit_hard_max_time**: 600000
- **solr_commit_hard_max_docs**: 1000
- **solr_commit_hard_open_searcher**: "true"
- **solr_max_warming_searchers**: 2
- **solr_lock_type**: native
- **solr_replication_mode**: 'disabled'. Can be *disabled*, *master* or *slave*
- **solr_replication_master_url**: none
- **solr_replication_poll_interval**: '00:01:00'
- **solr_replication_config_files**: 'schema.xml'
- **solr_lib_dirs**: here, you list the folders you use to import dependency libs for solr. Defaults to *['../lib', '../deps']*
- **solr_lib_paths**: here, you list jar files you want to include on your classpath. Defaults to *none*
- **solr_unlock_on_startup**: "true"
- **solr_filter_cache_size**: 512
- **solr_filter_cache_intial_size**: 512
- **solr_filter_cache_auto_warm_count**: 0
- **solr_query_result_cache_size**: 512
- **solr_query_result_cache_intial_size**: 512
- **solr_query_result_cache_auto_warm_count**: 0
- **solr_document_cache_size**: 512
- **solr_document_cache_intial_size**: 512
- **solr_document_cache_auto_warm_count**: 0

Dependencies
------------

alexanderjardim.tomcat

Example Playbook
-------------------------


```
- hosts: all
  vars:
    solr_installation_dir: '/home/vagrant/solr'
  roles:
  #simply calling the role, will install Solr with its default parameters. But with not any usefull cores/collections
  - { role: 'solr' }
  
  # calling the role with solr_action=install_core will install the given core.
  # in the example bellow, the core files will be taken from solr_local_config_dir
  - { role: 'solr',
      solr_action: 'install_core',
      solr_core_name: 'core0',
      solr_local_config_dir: '{{solr_local_dir}}/example/multicore/core0/'
    }

  # if you don't pass any paramters about where to take config files from, the solrconfig.xml 
  # will be generated using the solrconfig.xml.j2 template    
  - { role: 'solr',
      solr_action: 'install_core',
      solr_core_name: 'core1'
    }
  
  # you can also specify the solrconfig.xml and schema.xml files individually
  - { role: 'solr',
      solr_action: 'install_core',
      solr_core_name: 'core2',
      solr_local_config_file: '{{solr_local_dir}}/example/multicore/core1/conf/solrconfig.xml',
      solr_local_schema_file: '{{solr_local_dir}}/example/multicore/core1/conf/schema.xml'
    }
```    
License
-------

BSD

Author Information
------------------

alexander.ramos.jardim+solr@gmail.com
