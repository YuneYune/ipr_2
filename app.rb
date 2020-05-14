# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'json'
require_relative 'functions.rb'

set :bind, '0.0.0.0'
set :port, 1488

class MyApp < Sinatra::Base

  before do
    content_type 'application/json'
    headers "Content-Type" => "application/json"
  end

  get '/pass/:guid' do |id|

    begin
      connection = PG.connect :dbname => 'postgres', :user => 'postgres', :password => '676767'

      sql_select = connection.exec 'SELECT * FROM public."Passes";'


      sql_select.to_a.each do |item|
        # p '!!!!!!!!!!!!!!!' if item['GUID'] == id & is_valid?(item)
        p @pass = item if item['GUID'] == id
        time = Time.now
      end

      body "#{@pass.to_json}, #{Time.now}"

    rescue PG::Error => e
      val_error = e.message

    ensure
      connection&.close
    end
  end

# post '/pass' do
#   guid = generate_id
#   p JSON.parse(request.body.read)
# end

end
