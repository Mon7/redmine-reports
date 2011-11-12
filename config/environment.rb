require 'pdfkit'
if ENV['RACK_ENV'] == 'production'
  PDFKit.configure do |config|
    config.wkhtmltopdf = './bin/wkhtmltopdf-amd64'
  end
end
