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

connection = PG.connect dbname: 'postgres', user: 'postgres', password: '676767'

before do
  content_type 'application/json'
  headers "Content-Type" => "application/json"
  request.body.rewind
  @request_payload = request.body.read
end

get '/pass/:guid' do |id|

  begin
    pass = connection.exec("SELECT \"GUID\", \"FirstName\", \"LastName\", \"Patronymic\", \"PaspportNumber\", \"DateFrom\", \"DateTo\" FROM public.\"Passes\" WHERE \"GUID\" = '#{id}';").to_a
    p pass.class
    p pass.length
    if pass.empty?
      halt 404, 'NOT FOUND'
    else
      response.body = pass[0].to_json
    end
  rescue PG::Error => e
    e.message
  end
end

get '/pass/validate/:guid' do |id|
  begin
    pass = connection.exec("SELECT \"GUID\", \"FirstName\", \"LastName\", \"Patronymic\", \"PaspportNumber\", \"DateFrom\", \"DateTo\" FROM public.\"Passes\" WHERE \"GUID\" = '#{id}';").to_a
    halt 410, 'GONE' if valid?(pass[0]) == false
    status 200
  rescue PG::Error => e
    e.message
  end
end

delete '/pass/:guid' do |id|
  begin
    connection.exec("DELETE FROM public.\"Passes\" WHERE \"GUID\" = '#{id}';")
  rescue PG::Error => e
    response.body = e.message.to_json
  end
end

post '/pass/' do
  pass = JSON.parse @request_payload
  guid = SecureRandom.uuid
  begin
    connection.exec("INSERT INTO public.\"Passes\"(\"GUID\", \"FirstName\", \"LastName\", \"Patronymic\", \"PaspportNumber\", \"DateFrom\", \"DateTo\") VALUES ('#{guid}', '#{pass['first_name']}', '#{pass['last_name']}', '#{pass['patronymic']}', #{pass['passport_number'].to_i}, '#{Time.now.strftime('%F')}', '#{Date.today.next_month.strftime('%F')}');")
  rescue PG::Error => e
    p e
    response.body = e
  end
  status 200
  response.body = {guid: guid}.to_json
end

put '/pass/' do
  pass = JSON.parse @request_payload
  begin
    connection.exec("UPDATE public.\"Passes\" SET \"FirstName\"='#{pass['first_name']}', \"LastName\"='#{pass['last_name']}', \"Patronymic\"='#{pass['patronymic']}', \"PaspportNumber\"= #{pass['passport_number'].to_i}, \"DateFrom\"='#{pass['DateFrom']}', \"DateTo\"='#{pass['DateTo']}' WHERE \"GUID\" = '#{pass['guid']}';")
  rescue PG::Error => e
    p e
    body "#{e}"
  end
  status 200
end

def valid?(pass)
  year_now = Time.now.year.to_i
  month_now = Time.now.month.to_i
  day_now = Time.now.day.to_i

  valid_year = year_now.between?(pass['DateFrom'][0, 4].to_i, pass['DateTo'][0, 4].to_i)
  valid_month = month_now.between?(pass['DateFrom'][5, 2].to_i, pass['DateTo'][5, 2].to_i)
  if month_now == pass['DateFrom'][5, 2].to_i
    @valid_day_after = day_now >= pass['DateFrom'][8, 2].to_i
  end
  if month_now == pass['DateTo'][5, 2].to_i
    @valid_day_before = day_now <= pass['DateTo'][8, 2].to_i
  end
  valid_year && valid_month && (@valid_day_after || @valid_day_before) == true ? true : false
end
