
Installs [maven](https://maven.apache.org/). Usage:

    roles:
    - { role: jgoodall.maven3, maven_version: 3.1.1 }

See `defaults/main.yml` file for list of all options.

Maven requires Java, to download a Java role:

    ansible-galaxy install -r requirements.txt -p roles
