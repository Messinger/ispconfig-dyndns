#!/bin/sh

cd $APP_HOME
sudo -HEu NOBODY bundle exec rake db:migrate
rm -rf tmp/pids/puma.pid
sudo -HEu NOBODY bundle exec puma -e production
