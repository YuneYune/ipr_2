#UI-test
require 'selenium-webdriver'
require 'cucumber'
require 'open-uri'
require 'Mysql2'

require 'rest-client'

#base-ufr
require 'rspec/core'
require 'rspec/expectations'


Selenium::WebDriver.logger.level = :error


puts 'SYSTEM TIME = ' + Time.now.to_s

at_exit do
  puts 'SUPER END'
end
