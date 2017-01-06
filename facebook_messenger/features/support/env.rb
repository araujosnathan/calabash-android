if ENV['PLATFORM'] == 'ios'
  require 'calabash-cucumber/cucumber'
elsif ENV['PLATFORM'] == 'android'
  require 'calabash-android/cucumber'
end


require "yaml"
CONFIG = YAML.load_file("config/dev.yml")
