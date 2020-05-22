# frozen_string_literal: true

def send_get(path, headers = {})
  puts url = path
  log_rest_params "Url = #{url} ", 'payload = NULL ', "headers = #{headers} "
  RestClient.get(url, headers) do |response, _request, _result|
    @last_response = response
    # log_response_params @last_response.code, @last_response.headers, @last_response.body
    case response.code
    when 301, 302, 307
      @last_response = response.follow_redirection
    else
      @last_response = response
    end
  end
end

def send_post(url, payload, headers = {})
  log_rest_params "Url = #{url} ", "payload = #{payload} ", "headers = #{headers} "
  RestClient.post(url, payload, headers) {|response, _code| @last_response = response}
  log_response_params @last_response.code, @last_response.headers, @last_response.body
  @last_response
end

def send_put(url, payload, headers = {})
  log_rest_params "Url = #{url} ", "payload = #{payload} ", "headers = #{headers} "
  RestClient.put(url, payload, headers) {|response, _code| @last_response = response}
  log_response_params @last_response.code, @last_response.headers, @last_response.body
  @last_response
end

def send_delete(path, headers = {})
  # log_rest_params "Url = #{url} ", 'payload = NULL ', "headers = #{headers} "
  RestClient.delete(path, headers) do |response, _request, _result|
    case response.code
    when 301, 302, 307
      @last_response = response.follow_redirection
    else
      @last_response = response
    end
  end
end

# логируем запрос
def log_rest_params(url, payload, headers)
  puts __method__.to_s
  puts url
  puts payload
  puts headers
end

# логируем ответ
def log_response_params(code, headers, body)
  puts __method__.to_s
  puts "response_code = #{code} "
  puts "response_head = #{headers} "
  parsed = body && body.length >= 2 && (json_string? body) ? JSON.parse(body) : {}
  puts "response_body = #{JSON.pretty_generate(JSON.parse(parsed.to_json))} "
  puts "response_body = #{JSON.parse(parsed.to_json).to_s} "
end

# проверяем валидность json
def json_string?(foo)
  JSON.parse(foo)
  true
rescue StandardError
  false
end
