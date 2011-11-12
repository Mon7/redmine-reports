require 'pdfkit'

PDFKit.configure do |config|
  config.wkhtmltopdf = './bin/wkhtmltopdf-amd64'
end
