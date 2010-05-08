require 'apps/presto'
require 'apps/redirects'
require 'apps/www'
use WWW
use Redirects
run Presto::App
