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


before do
  content_type 'application/json'
  headers "Content-Type" => "application/json"
  request.body.rewind
  @request_payload = request.body.read
  @connection = PG.connect dbname: 'postgres', user: 'postgres', password: '676767'
end

after do
  @connection&.close
  # response.body = response.body.to_json
end

get '/pass/:guid' do |id|

  begin
    passes = @connection.exec('SELECT * FROM public."Passes";').to_a

    ids = passes.map { |item| item['GUID'] }
    halt 404, 'NOT FOUND' unless ids.include?(id)

    if ids.include?(id)
      passes.each do |item|
        halt 410, 'GONE' if item['GUID'] == id && valid?(item) == false
        if item['GUID'] == id && valid?(item)
          @valid_pass = item
          break
        end
      end
    end
    @valid_pass.to_json
  rescue PG::Error => e
    e.message
  end
end

delete '/pass/:guid' do |id|
  begin
    @connection.exec("DELETE FROM public.\"Passes\" WHERE \"GUID\" = '#{id}';")
  rescue PG::Error => e
    response.body = e.message.to_json
  end
end

post '/pass/' do
  status 200
  pass = JSON.parse @request_payload
  guid = generate_id
  begin
    @connection.exec("INSERT INTO public.\"Passes\"(\"GUID\", \"FirstName\", \"LastName\", \"Patronymic\", \"PaspportNumber\", \"DateFrom\", \"DateTo\") VALUES ('#{guid}', '#{pass['FirstName']}', '#{pass['LastName']}', '#{pass['Patronymic']}', #{pass['PassportNumber'].to_i}, '#{Time.now.strftime('%F')}', '#{Date.today.next_month.strftime('%F')}');")
  rescue PG::Error => e
    p e
    response.body = e
  end
  { body: guid }.to_json
end

put '/pass/' do
  status 200
  pass = JSON.parse @request_payload
  p pass
  begin
    @connection.exec("UPDATE public.\"Passes\" SET \"FirstName\"='#{pass['FirstName']}', \"LastName\"='#{pass['LastName']}', \"Patronymic\"='#{pass['Patronymic']}', \"PaspportNumber\"= #{pass['PassportNumber'].to_i}, \"DateFrom\"='#{pass['DateFrom']}', \"DateTo\"='#{pass['DateTo']}' WHERE \"GUID\" = '#{pass['guid']}';")
  rescue PG::Error => e
    p e
    body "#{e}"
  end
  { body: pass }.to_json
end

def generate_id
  hex = SecureRandom.hex.upcase
  indexes = [8, 13, 18, 23]
  indexes.each { |index| @id = hex.insert(index, '-') }
  @id
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
