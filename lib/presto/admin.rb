require 'sinatra/base'
require 'sinatra/activerecord'
require 'lib/presto/models'

class Presto::Admin < Sinatra::Base
  set :raise_errors, true
  set :public, './public/admin'
  set :views, './public/admin'

  get '/' do
    erb :index
  end
end