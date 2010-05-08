require 'apps/presto'
require 'apps/redirects'
require 'apps/www'

require 'rack/hoptoad'
use Rack::Hoptoad, ENV['hoptoad_key']

use WWW
use Redirects
run Presto::App