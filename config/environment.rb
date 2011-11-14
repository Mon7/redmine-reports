require 'pdfkit'
if ENV['RACK_ENV'] == 'production'
  PDFKit.configure do |config|
    config.wkhtmltopdf = './bin/wkhtmltopdf-amd64'
  end
end

require "redis"
REDIS_URL = ENV['REDISTOGO_URL'] || 'redis.//@localhost:6379/0'
REDIS_URI = URI.parse REDIS_URL
REDIS_CONF = {:host => REDIS_URI.host, :port => REDIS_URI.port, :password => REDIS_URI.password}
$redis = Redis.new REDIS_CONF
