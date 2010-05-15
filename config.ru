ENV['DATABASE_URL'] = 'postgresql://root@localhost/trevorturk'
# local pg postgresql://root@localhost/trevorturk
# local ae mysql://root@localhost/tturk_ae
# local wp mysql://root@localhost:8889/wp_2_9_2
# ActiveRecord::Base.logger = Logger.new(STDOUT)

require 'lib/presto/app'
# require 'lib/presto/admin'
require 'lib/rack/exception'
require 'lib/rack/redirects'
require 'lib/rack/www'
require 'hoptoad_notifier'

HoptoadNotifier.configure do |config|
  config.api_key = ENV['hoptoad_key']
end

use Rack::PublicExceptionPage if ENV['RACK_ENV'] == 'production' # top middleware
use HoptoadNotifier::Rack if ENV['hoptoad_key']
use WWW
use Redirects
# map '/presto' do
#   use Presto::Admin
# end
run Presto::App