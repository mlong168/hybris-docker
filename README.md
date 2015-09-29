How to install
--------------
**Requirements**

You will need VirtualBox, vagrant and ansible to be installed. ansible also requires Python and some Python modules to be installed.

Fast way to install VirtualBox and vagrant is to use brew cask. ansible can be installed with homebrew as well:

 - https://github.com/mlong168/mac-dev-playbook

To Provision Hyrbis locally (MacOSX and Ubuntu only) run the following.

  - **ansible-playbook -v -i ../shell/inventory .././ansible/deploy-osx.yml**
  - **ansible-playbook -v -i ../shell/inventory .././ansible/deploy-ubuntu.yml**

Start VM and Docker Apps
--------

Go to the **hybris-docker/development** directory and type 

- **vagrant up --provider docker --no-provision --no-parallel**

Vagrant will download the base box and provision it with docker and ansible using your configuration.

- To install Hybris in Docker: 
  - **BUILD_OPTS='install' vagrant provision hybris**
- To build and update master db: 
  - **BUILD_OPTS='updatemaster' vagrant provision hybris**
- To build and init the database:  
  - **BUILD_OPTS=’initmaster’ vagrant provision hybris**
- To run a build without database update: 
  - **vagrant provision hybris**

*Note that vagrant may ask for a sudo password. That's required when you're using NFS for folder synchronization.*

Once it's done, you'll be able to login into it using vagrant ssh command. The hybris container stores the source in the /opt/rccl-tourtrek directory.

 - **vagrant ssh $docker-app**

Connecting to Hybris Web
------------------------

**Localhost:**

 - HTTP URL: http://localhost:8000
 - HTTPS URL: https://localhost:8001 (https)

**Docker Container:**

 - HTTP URL: http://dockerhost:8000
 - HTTPS URL: https://dockerhost:8001 (https)

Control
-------

**VM**

Virtual machine can be controlled by running the following commands:

 - vagrant status
 - vagrant up OR vagrant up vagrant up $container
 - vagrant provision  OR vagrant provision $container
 - vagrant halt OR vagrant halt $container
 - vagrant destroy OR vagrant destroy $container

Hybris Restart
------
You can start and stop hybris by reloading the docker container:

 - vagrant reload hybris

Hybris Deploy
-------------

On first deploy the Hybris provision playbook will checkout the git repo (develop branch) and run any necessary configurations. It will also run through the normal Hybris build process and commence with initializing the MySQL database. 

To test any changes to code you that will need to rebuild the Hybris database. You can run the following from the **hybris-docker/development** directory:

 - BUILD_OPTS='updatemaster' vagrant provision hybris

Change the "branch" name to the one you are working on and want to test and change init and update to True or False depending on whether you would like to update the database or reinitialize. To skip both change both to False. 

These options can also be set in: /path/to/hybris-docker/ansible/vars/$build-option.yml

Customization
-------------

Feel free to customize ansible playbooks as you need. But keep in mind that your changes may be lost if you don't commit your changes. Probably it will be best if you keep your customizations in a separate roles which names do not overlap with the playbooks provided.
.
