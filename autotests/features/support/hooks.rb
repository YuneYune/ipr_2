# frozen_string_literal: true


Before('@rest') do |scenario|
  @counter = 0
  @scenarios_name = scenario.name
  configure_$connection_to_database if ENV['DbLogEnable'] == 'true'
end
