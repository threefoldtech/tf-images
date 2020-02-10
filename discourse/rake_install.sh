#! /bin/bash

set -ex
if [[ "$fresh_install" == "yes" ]];then
	su discourse -c 'bundle install --deployment --retry 3 --jobs 4 --verbose --without test development'
	DEV_RAKE='/var/www/discourse/vendor/bundle/ruby/2.6.0/gems/railties-6.0.1/lib/rails/tasks/dev.rake'
	if [[ -f $DEV_RAKE ]] ;then
	        echo " $DEV_RAKE file is exist "
	else
        	echo " $DEV_RAKE file does not exist "
        	cp /.dev.rake $DEV_RAKE
        	chown discourse:discourse $DEV_RAKE
	fi
	su discourse -c 'bundle exec rake db:migrate'
	su discourse -c 'bundle exec rake assets:precompile'
fi
