#! /usr/bin/env bash

cd /var/www/hyrax/hyrax-root/
SECRET_KEY_BASE={{ hyrax_secret_key_base }} HYRAX_POSTGRESQL_PASSWORD={{ hyrax_postgresqldatabase_user_password }} RAILS_ENV=production bundle exec rails runner "Hyrax::RepositoryFixityCheckService.fixity_check_everything" > /var/www/hyrax/fixitychecklog.log 2>&1
