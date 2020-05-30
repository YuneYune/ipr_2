# frozen_string_literal: true

require 'date'
require 'securerandom'
require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'json'

# require_relative 'functions'

set :bind, '0.0.0.0'
set :port, 1488

$connection = PG.connect dbname: 'postgres', user: 'postgres', password: '676767'

before do
  content_type 'application/json'
  headers "Content-Type" => "application/json"
  request.body.rewind
  @request_payload = request.body.read
end

get '/pass/:guid' do |id|
  pass = find_pass(id)
  begin
    if pass == false
      halt 404, 'NOT FOUND'
    else
      response.body = pass.to_json
    end
  rescue PG::Error => e
    e.message
  end
end

get '/pass/validate/:guid' do |id|
  pass = find_pass(id)
  begin
    if pass == false
      halt 404, 'NOT FOUND'
    elsif valid?(pass) == false
      halt 410, 'GONE'
    else
      status 200
    end
  rescue PG::Error => e
    e.message
  end
end


delete '/pass/:guid' do |id|
  pass = find_pass(id)
  begin
    if pass == false
      halt 404, 'NOT FOUND'
    else
      $connection.exec("DELETE FROM public.\"Passes\" WHERE \"GUID\" = '#{id}';")
    end
  rescue PG::Error => e
    e.message
  end
end

post '/pass/' do
  pass = JSON.parse @request_payload
  guid = SecureRandom.uuid
  begin
    $connection.exec("INSERT INTO public.\"Passes\"(\"GUID\", \"FirstName\", \"LastName\", \"Patronymic\", \"PaspportNumber\", \"DateFrom\", \"DateTo\") VALUES ('#{guid}', '#{pass['FirstName']}', '#{pass['LastName']}', '#{pass['Patronymic']}', #{pass['PaspportNumber'].to_i}, '#{Time.now.strftime('%F')}', '#{Date.today.next_month.strftime('%F')}');")
  rescue PG::Error => e
    e.message
  end
  status 200
  response.body = {guid: guid}.to_json
end

put '/pass/' do
  new_pass = JSON.parse @request_payload
  pass = find_pass(new_pass['guid'])
  begin
    if pass == false
      halt 404, 'NOT FOUND'
    else
      $connection.exec("UPDATE public.\"Passes\" SET \"FirstName\"='#{new_pass['FirstName']}', \"LastName\"='#{new_pass['LastName']}', \"Patronymic\"='#{new_pass['Patronymic']}', \"PaspportNumber\"= #{new_pass['PaspportNumber'].to_i}, \"DateFrom\"='#{new_pass['DateFrom']}', \"DateTo\"='#{new_pass['DateTo']}' WHERE \"GUID\" = '#{new_pass['guid']}';")
    end
  rescue PG::Error => e
    e.message
  end
  status 200
end

def valid?(pass)

  pass_from = Time.parse(pass['DateFrom'])
  pass_to = Time.parse(pass['DateTo'])

  Time.now > pass_from && Time.now < pass_to ? true : false
end

def find_pass(guid)
  pass = $connection.exec("SELECT \"GUID\", \"FirstName\", \"LastName\", \"Patronymic\", \"PaspportNumber\", \"DateFrom\", \"DateTo\" FROM public.\"Passes\" WHERE \"GUID\" = '#{guid}';").to_a
  if pass.empty?
    false
  else
    pass[0]
  end
end
