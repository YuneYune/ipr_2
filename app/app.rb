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
    $connection.exec("INSERT INTO public.\"Passes\"(\"GUID\", \"FirstName\", \"LastName\", \"Patronymic\", \"PaspportNumber\", \"DateFrom\", \"DateTo\") VALUES ('#{guid}', '#{pass['first_name']}', '#{pass['last_name']}', '#{pass['patronymic']}', #{pass['passport_number'].to_i}, '#{Time.now.strftime('%F')}', '#{Date.today.next_month.strftime('%F')}');")
  rescue PG::Error => e
    e.message
  end
  status 200
  response.body = { guid: guid }.to_json
end

put '/pass/' do
  new_pass = JSON.parse @request_payload
  pass = find_pass(new_pass['guid'])
  begin
    if pass == false
      halt 404, 'NOT FOUND'
    else
      $connection.exec("UPDATE public.\"Passes\" SET \"FirstName\"='#{new_pass['first_name']}', \"LastName\"='#{new_pass['last_name']}', \"Patronymic\"='#{new_pass['patronymic']}', \"PaspportNumber\"= #{new_pass['passport_number'].to_i}, \"DateFrom\"='#{new_pass['DateFrom']}', \"DateTo\"='#{new_pass['DateTo']}' WHERE \"GUID\" = '#{new_pass['guid']}';")
    end
  rescue PG::Error => e
    e.message
  end
  status 200
end

def valid?(pass)

  pass_year_from = Time.parse(pass['DateFrom']).year.to_i
  pass_year_to = Time.parse(pass['DateTo']).year.to_i
  pass_month_from = Time.parse(pass['DateFrom']).month.to_i
  pass_month_to = Time.parse(pass['DateTo']).month.to_i
  pass_day_from = Time.parse(pass['DateFrom']).day.to_i
  pass_day_to = Time.parse(pass['DateTo']).day.to_i

  year_now = Time.now.year.to_i
  month_now = Time.now.month.to_i
  day_now = Time.now.day.to_i

  valid_year = year_now.between?(pass_year_from, pass_year_to)
  valid_month = month_now.between?(pass_month_from, pass_month_to)
  if month_now == pass_month_from
    @valid_day_after = day_now >= pass_day_from
  elsif month_now == pass_month_to
    @valid_day_before = day_now <= pass_day_to
  end
  valid_year && valid_month && (@valid_day_after || @valid_day_before) == true ? true : false
end

def find_pass(guid)
  pass = $connection.exec("SELECT \"GUID\", \"FirstName\", \"LastName\", \"Patronymic\", \"PaspportNumber\", \"DateFrom\", \"DateTo\" FROM public.\"Passes\" WHERE \"GUID\" = '#{guid}';").to_a
  if pass.empty?
    false
  else
    pass[0]
  end
end
