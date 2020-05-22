# encoding: utf-8

require 'jsonpath'

When(/^Послали POST на URL "([^"]*)" с параметрами:$/) do |urn, table|
  variables = table.raw.flatten
  payload_hash = {
      "FirstName": variables[3],
      "LastName": variables[5],
      "Patronymic": variables[7],
      "PassportNumber": variables[9]
  }
  payload_hash = payload_hash.to_json
  headers_hash = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  send_post(urn, payload_hash, headers_hash)
  @requests_payload = payload_hash #json
end

When(/^Послали PUT на URL "([^"]*)" с параметрами:$/) do |urn, table|
  variables = table.raw.flatten
  payload_hash = {
      "guid": variables[3],
      "FirstName": variables[5],
      "LastName": variables[7],
      "Patronymic": variables[9],
      "PassportNumber": variables[11],
      "DateFrom": variables[13],
      "DateTo": variables[15]
  }
  payload_hash = payload_hash.to_json
  headers_hash = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  send_put(urn, payload_hash, headers_hash)
  @requests_payload = payload_hash #json
end

When(/^Послали DELETE "([^"]*)" запрос$/) do |url|
  @response = send_delete url
  log_response_params @last_response.code, @last_response.headers, @last_response.body
  @last_response = @response
end

When(/^Удалили (.*) с id, которое будем добавлять, послав DELETE запрос на URL "(.*)"$/) do |unnecessary, url|
  headers_hash = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  send_delete(url, headers_hash)
end

When(/^Убедились, что мы (.*) (.*), сравнив параметры (.*) и (.*) запросов$/) do |verb, type, meth1, meth2|
  @last_response = @last_response.body
  if type == 'заказ'
    @requests_payload = JSON.parse @requests_payload
    @last_response = JSON.parse @last_response
    @requests_payload.delete('shipDate')
    @last_response.delete('shipDate')
  end
  expect(@last_response == @requests_payload).to be true
end

When(/^Убедились, что мы удалили (.*)$/) do |type|
  expect(@last_response.code).to eq(404)
end


When(/^Проверили, что http status code == (\d*)$/) do |code|
  expect(@last_response.code.to_s).to eq(code)
end

When(/^Проверили, что status code == (\d*) или (\d*)$/) do |code1, code2|
  expect(@last_response.code.to_s).to eq(code1).or eq(code2)
end

When(/^Послали GET "(.*)" запрос$/) do |url|
  @response = send_get url
  log_response_params @last_response.code, @last_response.headers, @last_response.body
  @last_response = @response
end

