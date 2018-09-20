STATUS: PRE-ALPHA

# hyrax-ansible
Ansible playbook for configuring a Hyrax IR.

It is hoped that this script will be a starting point for teams running Hyrax-based IRs in production.
The idea is similar to https://github.com/Islandora-Devops/claw-playbook

All roles assume services (Nginx, Fedora 4, PostgreSQL) are installed on one machine and communicate using UNIX sockets or the loopback interface. For large deployments, you'll want to edit these roles so that services are deployed on different machines and that communication between them is encrypted.

This playbook is being tested against CentOS 7, Debian 9, and Ubuntu 18.04. A Vagrantfile is available at https://github.com/cu-library/hyrax-ansible-testvagrants.

`prepare.sh` is a shell script which downloads or complies the necessary executables. Run this before running the playbook.

`install_hyrax_on_localhost.yml` is a test playbook which runs the provided roles against localhost.

What does production-ready mean? A production ready instance of Hyrax should be secure. It should be regularly backed-up. It should be easy to update. Finally, it should have good performance.

## Security

INCOMPLETE

The services running within the VM should ensure data is protected from unauthorized access and modification. If one were to gain access to a nonprivileged Linux user account, one should not be able to access or modify any IR data. *Currently, this is not true of these roles. Some services are available to any Linux user.*

Attacks like remote code execution, XSS, SQL injection should be mitigated. Remote users should not be able to read or alter the filesystem in unexpected ways. *These roles still need a more thorough review against these types of attacks.*

## Backups

INCOMPLETE

Fedora 4, PostgreSQL, and the Hyrax user files (derivatives, logs, etc) should be backed up regularly. These roles will add cron jobs for backing up data to `hyrax_backups_directory`. It is up to local system administrators to copy that data to tape or to services like OLRC.

## Updates

INCOMPLETE

Where possible, it should be easy to keep a production server up-to-date. This means these roles should utilize well-known package repositories and package management tools when possible. Roles should be as idempotent and 'low impact' as possible, to encourage system administrators to run them regularly. Local modifications to community code should be minimal.

## Performance

INCOMPLETE

These roles should install Hyrax so that it has good performance (max 500ms for most requests) on a "medium sized" server (4 core, 4GB RAM) when being used for typical workloads (documents and images, some multimedia, less than 10,000 digital objects). Community recommended software versions and configuration should be used.

## Variables

|Variable|Notes|
|---|---|
|`fedora4_postgresqldatabase_user_password` | The password used by fedora4 to connect to Postgresql. Secure |
|`hyrax_backups_directory` | The location where backup files will be created. |
|`java_openjdk_package` | The name used by the `package` module when installing the Java JDK. Per-Distro |
|`postgresql_contrib_package` | The name used by the `package` module when installing Postgresql's additional features. Per-Distro |
|`postgresql_server_package` | The name used by the `package` module when installing the Postgresql server. Per-Distro |
|`python_psycopg2_package` | The name used by the `package` module when installing the Python Postgresql library (used by Ansible). Per-Distro |
|`redis_package` | The name used by the `package` module when installing Redis. Per-Distro |
|`tomcat_admin_package` | The name used by the `package` module when installing the tomcat manager webapps. Per-Distro |
|`tomcat_fedora4_conf_path` | The path for the configuration file which sets JAVA_OPTS for Fedora4. Per-Distro |
|`tomcat_fedora4_war_path` | The path at which the fedora4 war file will be copied. Per-Distro |
|`tomcat_group` | The primary group for the tomcat service user. Per-Distro |
|`tomcat_package` | The name used by the `package` module when installing tomcat. Per-Distro |
|`tomcat_service_name` | The name of the tomcat service. Per-Distro |
|`tomcat_user_password` | The password used to build the tomcat-users.xml file. Secure |
|`tomcat_user` | The user which runs the tomcat service. Per-Distro |
|`tomcat_users_conf_path` | The path for tomcat-users.xml. Per-Distro |

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
The software version will depend on the distribution and release. For example, version 7 or 8 of Tomcat might be installed.

However, some software is installed at a specific version:

* Java v1.8 (OpenJDK)
* Fedora Repository v4.7.5
* Solr v7.4.0
* Node.js v10.x

Nginx is installed using that project's pre-built packages for the stable version, and not the default distribution repositories.
Node.js is installed using the NodeSource repositories. 

