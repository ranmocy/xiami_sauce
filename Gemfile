source 'http://ruby.taobao.org'
# source 'https://rubygems.org'

gemspec

gem 'guard'
gem 'guard-bundler'
gem 'guard-rspec'

gem 'rb-fsevent', '>= 0.3.9'
gem 'rb-inotify', '>= 0.5.1'

# Notification System
gem 'terminal-notifier-guard', :require => RUBY_PLATFORM.downcase.include?("darwin") ? 'terminal-notifier-guard' : nil
gem 'libnotify', :require => RUBY_PLATFORM.downcase.include?("linux") ? 'libnotify' : nil
