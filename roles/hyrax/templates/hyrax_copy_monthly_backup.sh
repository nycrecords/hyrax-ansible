#! /usr/bin/env bash

# What's the oldest file in the weekly backups directory?
# Neat trick from https://stackoverflow.com/questions/22727107/how-to-find-the-last-field-using-cut
oldest=$(ls -lAt "{{ hyrax_backups_directory }}/weekly" | tail -n 1 | rev | cut -f 1 -d ' ' | rev)

# Move the oldest file to the monthly directory.
(echo -n "$(date --rfc-3339=seconds) - monthly copy - " && mv "{{ hyrax_backups_directory }}/weekly/$oldest" "{{ hyrax_backups_directory }}/monthly/" && echo "Moved $oldest to monthly backup directory") >> /var/log/hyrax/backup.log 2>&1

# Delete older backups
(echo -n "$(date --rfc-3339=seconds) - delete older monthly backups - " && find "{{ hyrax_backups_directory }}/monthly" -mindepth 1 -maxdepth 1 -mtime +365 -name '*.tar.gz' -type f -delete -print | grep --color=never 'tar.gz' || echo "none found") >> /var/log/hyrax/backup.log 2>&1
