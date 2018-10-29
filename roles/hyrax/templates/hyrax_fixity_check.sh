#! /usr/bin/env bash

cd /var/www/hyrax/hyrax-root/
export SECRET_KEY_BASE={{ hyrax_secret_key_base }}
export HYRAX_POSTGRESQL_PASSWORD={{ hyrax_postgresqldatabase_user_password }}
export RAILS_ENV=production
(echo -n "$(date --rfc-3339=seconds) " && /usr/local/bin/bundle exec rails runner "Hyrax::RepositoryFixityCheckService.fixity_check_everything") >> /var/log/hyrax/fixitycheck.log 2>&1
