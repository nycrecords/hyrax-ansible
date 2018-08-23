STATUS: PRE-ALPHA

# hyrax-ansible
Ansible playbook for configuring a production-ready Hyrax IR.

This project is in development. 
It is hoped that this script will be a starting point for teams running Hyrax-based IRs in production. 
The idea is similar to https://github.com/Islandora-Devops/claw-playbook 

This playbook is being tested against CentOS 7, Debian 9, and Ubuntu 18.04. 

`prepare.sh` is a shell script which downloads or complies the necessary executables. Run this before running the playbook.

## Software versions:

* Fedora Repository 4.7.5

## Assumptions and Decisions

Here are a list of assumptions and decisions made in this playbook.
 
* Backups are created in `/var/backups`
