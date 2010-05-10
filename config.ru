require 'apps/presto'
require 'apps/redirects'
require 'apps/www'
require 'rack/hoptoad'

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
else
  use Rack::PublicExceptionPage
end

use Rack::Hoptoad, ENV['hoptoad_key']
use WWW
use Redirects
run Presto::App