require 'sinatra/base'
require 'active_record'
require 'wp'
require 'erubis'

class AE < Sinatra::Base

  set :views, File.dirname(__FILE__) + '/themes/test'

  dbconfig = YAML.load(File.read('config/database.yml'))
  ActiveRecord::Base.establish_connection dbconfig[ENV['RACK_ENV']]

  get '/' do
    @posts = Post.all(:limit => 10)
    erubis :index
  end
end