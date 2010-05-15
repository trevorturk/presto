require 'sinatra/base'
require 'sinatra/activerecord'
require 'lib/presto/models'

class Presto::Admin < Sinatra::Base
  set :raise_errors, true
  set :public, './public/admin'
  set :views, './public/admin'

  if ENV['RACK_ENV'] == 'production'
    raise 'no user/pass' unless ENV['presto_user'] && ENV['presto_pass']
    use Rack::Auth::Basic do |user, pass|
      [user, pass] == [ENV['presto_user'], ENV['presto_pass']]
    end
  end

  get '/' do
    erb :index
  end
end