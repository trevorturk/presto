ENV['DATABASE_URL'] = 'postgres://root@localhost/trevorturk' if ENV['RACK_ENV'] == 'development'
# ENV['DATABASE_URL'] = 'mysql://root@localhost/wp_2_9_2' if ENV['RACK_ENV'] == 'development'

require 'lib/presto/admin'
require 'lib/presto/app'

require 'lib/rack/exception'
require 'lib/rack/redirects'
require 'lib/rack/no_www'

require 'hoptoad_notifier'

HoptoadNotifier.configure do |config|
  config.api_key = ENV['hoptoad_key']
end

map '/' do
  use Rack::PublicExceptionPage if ENV['RACK_ENV'] == 'production'
  use HoptoadNotifier::Rack if ENV['hoptoad_key']
  use NoWWW
  use Redirects
  run Presto::App
end

map '/presto' do
  run Presto::Admin
end