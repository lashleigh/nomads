require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

SECRET = ENV['CLOUDMAILIN_SECRET']

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
