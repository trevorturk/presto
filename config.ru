require 'app'
require 'lib/rack/exception'
require 'lib/rack/redirects'
require 'lib/rack/www'
require 'hoptoad_notifier'

HoptoadNotifier.configure do |config|
  config.api_key = ENV['hoptoad_key']
end

use HoptoadNotifier::Rack if ENV['hoptoad_key']
use Rack::PublicExceptionPage if ENV['RACK_ENV'] == 'production'
use WWW
use Redirects
run Presto::App