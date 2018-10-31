#! /usr/bin/env bash

# What's the oldest file in the daily backups directory?
oldest=$(ls -lAt "{{ hyrax_backups_directory }}/daily" | tail -n 1 | rev | cut -f 1 -d ' ' | rev)

# Move the oldest file to the weekly directory.
(echo -n "$(date --rfc-3339=seconds) - weekly copy - " && mv "{{ hyrax_backups_directory }}/daily/$oldest" "{{ hyrax_backups_directory }}/weekly/" && echo "Moved $oldest to weekly backup directory") >> /var/log/hyrax/backup.log 2>&1

# Delete older backups
(echo -n "$(date --rfc-3339=seconds) - delete older weekly backups - " && find "{{ hyrax_backups_directory }}/weekly" -mindepth 1 -maxdepth 1 -mtime +31 -name '*.tar.gz' -type f -delete -print) >> /var/log/hyrax/backup.log 2>&1
