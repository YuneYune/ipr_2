# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'json'
require 'securerandom'
# require_relative 'functions'

set :bind, '0.0.0.0'
set :port, 1488


before do
  content_type 'application/json'
  headers "Content-Type" => "application/json"
  @connection = PG.connect :dbname => 'postgres', :user => 'postgres', :password => '676767'
end

after do
  @connection&.close
end

get '/pass/:guid' do |id|

  begin
    passes = @connection.exec('SELECT * FROM public."Passes";').to_a

    ids = passes.map { |item| item['GUID'] }
    halt 404, 'NOT FOUND' unless ids.include?(id)

    if ids.include?(id)
      passes.each do |item|
        halt 410, 'GONE' if item['GUID'] == id && !is_valid?(item)
        if item['GUID'] == id && is_valid?(item)
          @valid_pass = item
          break
        end
      end
    end

    body "#{@valid_pass.to_json}"

  rescue PG::Error => e
    e.message
  end
end

get '/pass1' do
  [200, {'zalupa' => '1'}, "Hello from Sinatra!"]
end

post "/post" do
  p x = request.body.read
  [200, x, "Hello from Sinatra!"]
end


def generate_id
  hex = SecureRandom.hex.upcase
  indexes = [8, 13, 18, 23]
  indexes.each do |index|
    hex.insert(index, '-')
  end
  hex
end

def is_valid?(pass)
  year_now = Time.now.year.to_i
  month_now = Time.now.month.to_i
  day_now = Time.now.day.to_i

  year_now.between?(pass['DateFrom'][0, 4].to_i, pass['DateTo'][0, 4].to_i)
  month_now.between?(pass['DateFrom'][5, 2].to_i, pass['DateTo'][5, 2].to_i)
  day_now >= pass['DateFrom'][8, 2].to_i if month_now == pass['DateFrom'][5, 2].to_i
  day_now <= pass['DateTo'][8, 2].to_i if month_now == pass['DateTo'][5, 2].to_i
end
