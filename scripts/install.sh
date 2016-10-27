#!/bin/sh

echo "Base setup of Dyndns Application Server"
echo "Ensure you have a running ruby > 2.1 with a writable gem folder"
echo "Best way is using RVM"

echo "bundler is required"
gem install bundler

echo "Installing Gems"

bundle install

echo "setting up phusion passenger and builtin nginx"
passenger-config build-native-support
passenger-config install-standalone-runtime

echo "Done "
