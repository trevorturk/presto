require 'app'
require 'lib/rack/redirects'
require 'lib/rack/www'
use WWW
use Redirects
run Presto::App