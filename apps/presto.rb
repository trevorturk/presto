require 'sinatra/base'

require 'active_record'
require 'will_paginate'
require 'hoptoad_notifier'

require 'lib/presto/models'
require 'lib/presto/helpers'

class Presto::App < Sinatra::Base
  configure do
    set :public, File.dirname(__FILE__) + '/../public'
    set :views, File.dirname(__FILE__) + '/../public/themes/trevorturk'
    set :logging, true

    dbconfig = YAML.load(File.read('config/database.yml'))
    ActiveRecord::Base.establish_connection dbconfig[ENV['RACK_ENV']]
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  enable :raise_errors
  use HoptoadNotifier::Rack
  HoptoadNotifier.configure do |config|
    config.api_key = ENV['hoptoad_key']
  end

  helpers do
    include Rack::Utils, Presto::Helpers
    alias_method :h, :escape_html
  end

  before do
    @options = Presto::Option.get_all
  end

  get '/' do
    @posts = Presto::Post.published.recent.all.paginate(:page => params[:page], :per_page => @options['posts_per_page'])
    erb :index
  end

  get '/:year/:month/:day/:post_name/' do
    @posts = Presto::Post.published.find_by_permalink!(params).to_a
    @comments = Presto::Comment.approved.all :conditions => {:comment_post_ID => @posts.first.ID}, :order => 'comment_date asc'
    erb :index
  end

  get '/feed/' do
    @posts = Presto::Post.published.recent.all(:limit => @options['posts_per_rss'])
    erb :feed
  end

  get '/hoptoad/' do
    raise "Kaboom!"
  end

  # not_found do
  #   redirect '/?not_found=1', 301
  # end
end