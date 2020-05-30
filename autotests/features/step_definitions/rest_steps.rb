# encoding: utf-8

require 'jsonpath'

When(/^Послали POST на URL "([^"]*)" с параметрами:$/) do |urn, table|
  variables = table.raw.flatten
  payload_hash = Hash[*variables].reject { |k| k == 'key' }.to_json
  headers_hash = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  send_post(urn, payload_hash, headers_hash)
  @requests_payload = payload_hash #json
end

When(/^Послали PUT на URL `([^"]*)` с параметрами:$/) do |urn, table|
  variables = table.raw.flatten
  payload_hash = Hash[*variables].reject { |k| k == 'key' }.to_json
  headers_hash = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
  send_put(urn, payload_hash, headers_hash)
  @requests_payload = payload_hash #json
end

When(/^Послали PUT запрос с id пропуска последнего POST запроса и параметрами:$/) do |table|
  variables = table.raw.flatten
  pass = Hash[*variables].reject { |k| k == 'key' }
  steps %{
    * Послали PUT на URL `http://localhost:1488/pass/` с параметрами:
      | key             | value                      |
      | guid            | #{@last_id}                |
      | FirstName      | #{pass['FirstName']}      |
      | LastName       | #{pass['LastName']}       |
      | Patronymic      | #{pass['Patronymic']}      |
      | PaspportNumber | #{pass['PaspportNumber']} |
      | DateFrom        | #{pass['DateFrom']}        |
      | DateTo          | #{pass['DateTo']}          |
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

When(/^Делаем GET запрос с id пропуска последнего POST запроса$/) do
  step "Послали GET \"http://localhost:1488/pass/#{@last_id}\" запрос"
end

When(/^Проверяем валидность пропуска, делая ГЕТ запрос с запомненным id$/) do
  step "Послали GET \"http://localhost:1488/pass/validate/#{@last_id}\" запрос"
end

When(/^Делаем GET запрос с id пропуска последнего POST запроса и запоминаем инф. о пропуске$/) do
  step 'Делаем GET запрос с id пропуска последнего POST запроса'
  @last_pass = JSON.parse @last_response
end

When(/^Убедились, что в теле ответа есть вся инфа о пропуске$/) do
  subset = ['GUID', 'FirstName', 'LastName', 'Patronymic', 'PaspportNumber', 'DateFrom', 'DateTo']
  subset.each { |item| expect(@last_pass.has_key?(item)).to be true }
end

When(/^Убедились, что инф. в пропуске соответствует параметрам:$/) do |table|
  variables = table.raw.flatten
  expected_hash = Hash[*variables].reject { |k| k == 'key' }
  keys = expected_hash.keys
  pass = JSON.parse @last_response
  keys.each { |key| expect(pass[key] == expected_hash[key]).to be true }
end

When(/^Убедились, что в ответе есть id пропуска$/) do
  pass = JSON.parse @last_response
  expect(pass.has_key?('guid')).to be true
end
