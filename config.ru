require 'app'
require 'lib/rack/redirects'
require 'lib/rack/www'

require 'hoptoad_notifier'
HoptoadNotifier.configure do |config|
  config.api_key = ENV['hoptoad_key']
end
use HoptoadNotifier::Rack

use WWW
use Redirects
run Presto::App