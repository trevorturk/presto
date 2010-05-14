require 'app'
require 'lib/rack/redirects'
require 'lib/rack/www'
require 'rack/hoptoad'
use Rack::Hoptoad, ENV['hoptoad_key']
use WWW
use Redirects
run Presto::App