require 'sinatra/base'
require 'lib/presto/models'
require 'lib/presto/helpers'

class Presto::Admin < Sinatra::Base
  set :raise_errors, true
  set :views, './views/admin'

  helpers Presto::Helpers

  configure do
    dbconfig = YAML.load(File.read('config/database.yml'))
    ActiveRecord::Base.establish_connection dbconfig[ENV['RACK_ENV']]
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  get '/' do
      'hello'
  end
end