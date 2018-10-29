#! /usr/bin/env bash

# Fcrepo
(echo -n "$(date --rfc-3339=seconds) - fcrepo - " && curl --silent -X POST -d "{{ hyrax_backups_directory }}/current/fcrepo" "localhost:8080/fcrepo/rest/fcr:backup") >> /var/log/hyrax/backup.log 2>&1
(echo -n "$(date --rfc-3339=seconds) - fcrepo - size:" &&  du -hs "{{ hyrax_backups_directory }}/current/fcrepo" | cut -f 1) >> /var/log/hyrax/backup.log 2>&1

# PostgreSQL
(echo -n "$(date --rfc-3339=seconds) - postgres - " && su - postgres -c "pg_dumpall --file={{ hyrax_backups_directory }}/current/postgres/backup.sql") >> /var/log/hyrax/backup.log 2>&1
(echo -n "$(date --rfc-3339=seconds) - postgres - size:" &&  du -hs "{{ hyrax_backups_directory }}/current/postgres" | cut -f 1) >> /var/log/hyrax/backup.log 2>&1

# Redis
(echo -n "$(date --rfc-3339=seconds) - redis - " && cp /var/lib/redis/dump.rdb "{{ hyrax_backups_directory }}/current/redis/dump.rdb") >> /var/log/hyrax/backup.log 2>&1
(echo -n "$(date --rfc-3339=seconds) - redis - size:" &&  du -hs "{{ hyrax_backups_directory }}/current/redis" | cut -f 1) >> /var/log/hyrax/backup.log 2>&1

# Hyrax
(echo -n "$(date --rfc-3339=seconds) - hyrax - " && tar -cf "{{ hyrax_backups_directory }}/current/hyrax/hyrax-root.tar" -C /var/www/hyrax/ hyrax-root) >> /var/log/hyrax/backup.log 2>&1
(echo -n "$(date --rfc-3339=seconds) - hyrax - size:" &&  du -hs "{{ hyrax_backups_directory }}/current/hyrax" | cut -f 1) >> /var/log/hyrax/backup.log 2>&1

# All together, now!
(echo -n "$(date --rfc-3339=seconds) - archive all - " && tar -zcf "{{ hyrax_backups_directory }}/daily/hyrax-backup.tar.gz" -C "{{ hyrax_backups_directory }}/current" *) >> /var/log/hyrax/backup.log 2>&1
(echo -n "$(date --rfc-3339=seconds) - archive all - size:" &&  du -hs "{{ hyrax_backups_directory }}/daily/" | cut -f 1) >> /var/log/hyrax/backup.log 2>&1
