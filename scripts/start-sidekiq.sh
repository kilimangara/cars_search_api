#!/bin/sh

set -e

bundle install
bundle exec sidekiq -C config/sidekiq.yml
