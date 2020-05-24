# encoding: utf-8

require 'jsonpath'

When(/^Послали POST на URL "([^"]*)" с параметрами:$/) do |urn, table|
  variables = table.raw.flatten
  payload_hash = {
      "first_name": variables[3],
      "last_name": variables[5],
      "patronymic": variables[7],
      "passport_number": variables[9]
  }
  payload_hash = payload_hash.to_json
  headers_hash = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  send_post(urn, payload_hash, headers_hash)
  @requests_payload = payload_hash #json
end

When(/^Послали PUT на URL `([^"]*)` с параметрами:$/) do |urn, table|
  variables = table.raw.flatten
  payload_hash = {
      "guid": variables[3],
      "first_name": variables[5],
      "last_name": variables[7],
      "patronymic": variables[9],
      "passport_number": variables[11],
      "DateFrom": variables[13],
      "DateTo": variables[15]
  }
  payload_hash = payload_hash.to_json
  headers_hash = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  send_put(urn, payload_hash, headers_hash)
  @requests_payload = payload_hash #json
end

When(/^Послали PUT запрос с id пропуска последнего POST запроса и параметрами:$/) do |table|
  variables = table.raw.flatten
  steps %{
    * Послали PUT на URL `http://localhost:1488/pass/` с параметрами:
      | key             | value            |
      | guid            | #{@last_id}      |
      | first_name      | #{variables[3]}  |
      | last_name       | #{variables[5]}  |
      | patronymic      | #{variables[7]}  |
      | passport_number | #{variables[9]}  |
      | DateFrom        | #{variables[11]} |
      | DateTo          | #{variables[13]} |
  }
end

When(/^Послали DELETE "([^"]*)" запрос$/) do |url|
  @response = send_delete url
  log_response_params @last_response.code, @last_response.headers, @last_response.body
  @last_response = @response
end

When(/^Делаем DELETE запрос с id пропуска последнего POST запроса$/) do
  @response = send_delete "http://localhost:1488/pass/#{@last_id}"
  log_response_params @last_response.code, @last_response.headers, @last_response.body
  @last_response = @response
end


When(/^Убедились, что http status code == (\d*)$/) do |code|
  expect(@last_response.code.to_s).to eq(code)
end

When(/^Убедились, что инф. в пропуске обновилась$/) do
  expect(@last_response.code.to_s).to eq(code)
end

When(/^Запомнили id пропуска$/) do
  @last_id = JSON.parse(@last_response)['guid']
end

When(/^Проверили, что status code == (\d*) или (\d*)$/) do |code1, code2|
  expect(@last_response.code.to_s).to eq(code1).or eq(code2)
end

When(/^Послали GET "(.*)" запрос$/) do |url|
  @response = send_get url, {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  log_response_params @last_response.code, @last_response.headers, @last_response.body
  @last_response = @response
end

When(/^Делаем GET запрос с id пропуска последнего POST запроса и запоминаем инф. о пропуске$/) do
  @response = send_get "http://localhost:1488/pass/#{@last_id}", {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  log_response_params @last_response.code, @last_response.headers, @last_response.body
  @last_response = @response
  @last_pass = JSON.parse @last_response
end

When(/^Убедились, что в теле ответа есть вся инфа о пропуске$/) do
  pass = JSON.parse @last_response
  subset = ['GUID', 'FirstName', 'LastName', 'Patronymic', 'PaspportNumber', 'DateFrom', 'DateTo']
  subset.each { |item| expect(pass.has_key? item).to be true }
end

When(/^Убедились, что инф. в пропуске соответствует параметрам:$/) do |table|
  variables = table.raw.flatten
  subset = [variables[3], variables[5], variables[7], variables[9], variables[11], variables[13]]
  subset.each { |item| expect(@last_pass.has_value? item).to be true }
end
