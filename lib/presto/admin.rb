require 'sinatra/base'
require 'lib/presto/models'
require 'lib/presto/helpers'

class Presto::Admin < Sinatra::Base
  set :raise_errors, true
  set :views, './public/admin'
  set :database, ENV['DATABASE_URL']

  helpers Presto::Helpers

  get '/' do
    'hello'
  end
end