require 'sinatra/base'
require 'lib/presto/models'

class Presto::Admin < Sinatra::Base
  set :raise_errors, true
  set :public, './public/admin'
  set :views, './public/admin'
  set :database, ENV['DATABASE_URL']

  get '/' do
    erb :index
  end
end