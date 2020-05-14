# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'json'

get '/pass/:guid' do |id|
  'Hello asd'
  "Hi, #{id}"

  begin
    connection = PG.connect :dbname => 'postgres', :user => 'postgres', :password => '676767'

    t_messages = connection.exec 'SELECT * FROM public."Passes";'

    x = t_messages.to_a
    x.each do |item|
      p item.values
    end

      # PG::Result

  rescue PG::Error => e
    val_error = e.message

  ensure
    connection.close if connection
  end
end

post '/pass' do


end
