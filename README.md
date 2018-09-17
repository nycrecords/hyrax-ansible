STATUS: PRE-ALPHA

# hyrax-ansible
Ansible playbook for configuring a production-ready Hyrax IR.

It is hoped that this script will be a starting point for teams running Hyrax-based IRs in production.
The idea is similar to https://github.com/Islandora-Devops/claw-playbook

All services are installed on one machine. For very large deployments, you might want to edit these roles so that services are deployed on different machines.

This playbook is being tested against CentOS 7, Debian 9, and Ubuntu 18.04. A Vagrantfile is available at https://github.com/cu-library/hyrax-ansible-testvagrants.

`prepare.sh` is a shell script which downloads or complies the necessary executables. Run this before running the playbook.

`hyrax.yml` is a test playbook which runs the provided roles against localhost.

## Variables

|Variable|Notes|
|---|---|
|`fedora4_postgresqldatabase_user_password` | The password used by fedora4 to connect to Postgresql. Secure |
|`hyrax_backups_directory` | The location where backup files will be created. |
|`java_openjdk_package` | The name used by the `package` module when installing the Java JDK. Per-Distro |
|`postgresql_contrib_package` | The name used by the `package` module when installing postgresql's additional features. Per-Distro |
|`postgresql_server_package` | The name used by the `package` module when installing the postgresql server. Per-Distro |
|`python_psycopg2_package` | The name used by the `package` module when installing the Python Postgresql library (used by Ansible). Per-Distro |
|`tomcat_admin_package` | The name used by the `package` module when installing the tomcat manager webapps. Per-Distro |
|`tomcat_package` | The name used by the `package` module when installing tomcat. Per-Distro |
|`tomcat_user_password` | The password used to build the tomcat-users.xml file. Secure |

**Per-Distro**: Different value for different OSs. The test playbook uses

```
vars_files:
    - "vars/common.yml"
    - "vars/{{ ansible_distribution }}.yml"
```

and per-distribution variable files to provide different variables for different distributions.

**Secure**: Variables which should be different per-host and stored securely using Ansible Vaults or a tool like Hashicorp Vault. The test playbook insecurely puts these variables in `vars/common.yml`.

## Software versions

Most software in the provided roles is installed using yum or apt from the default distribution repositories.
The software version will depend on the distribution and release.

However, some software is installed at a specific version:

* Java 1.8 (OpenJDK)
* Fedora Repository 4.7.5
* Tomcat 7
