require 'uri'
require 'net/http'
require 'json'

require 'sql_formatter_web_interface/version'

class SqlFormatterWebInterface
  API_URI = 'https://sqlformat.org/api/v1/format'.freeze

  def initialize(sql)
    @sql = sql
  end

  def format(**options)
    uri = URI API_URI
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    body = URI.encode_www_form options.merge sql: @sql

    response = https.post(uri.path, body, 'Content-Type' => 'application/x-www-form-urlencoded')
    JSON.parse(response.body)['result']
  end
end
