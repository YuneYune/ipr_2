# UI-test
require 'cucumber'
require 'open-uri'

require 'rest-client'

# base-ufr
require 'rspec/core'
require 'rspec/expectations'


puts 'SYSTEM TIME = ' + Time.now.to_s

at_exit do
  puts 'SUPER END'
end
