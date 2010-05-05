require 'sinatra/base'

require 'lib/will_paginate_helpers.rb'
require 'lib/wordpress_helpers.rb'
require 'lib/wordpress_models.rb'

class Presto < Sinatra::Base
  configure do
    set :public, File.dirname(__FILE__) + '/public'
    set :views, File.dirname(__FILE__) + '/public/themes/trevorturk'
    set :logging, true

    dbconfig = YAML.load(File.read('config/database.yml'))
    ActiveRecord::Base.establish_connection dbconfig[ENV['RACK_ENV']]
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  helpers do
    include Rack::Utils, WordPressHelpers, WillPaginateHelpers
    alias_method :h, :escape_html
  end

  before do
    @options = Option.get_all # e.g. <%= @options['blogname'] %>
  end

  get '/' do
    if params[:p]
      @posts = Post.published.find(params[:p], :include => :approved_comments).to_a
      erb :index # TODO prefer single.erubis
    else
      @posts = Post.published.recent.all.paginate(:page => params[:page], :per_page => @options['posts_per_page'])
      erb :index
    end
  end

  # common wp post routes:
  # default: /?p=123 (above)
  # day and name: /2010/05/04/sample-post/ (below)
  # month and name: /2010/05/sample-post/ (TODO)
  # numeric: /archives/123 (TODO)
  # TODO catch (and redirect?) old page routes, e.g. /page/2/

  get '/:year/:month/:day/:post_name/?' do
    @posts = Post.published.find_by_permalink!(params).to_a
    erb :index # TODO prefer single.erubis
  end

  # TODO not found and errors

  # not_found do
  #   erb :not_found
  # end

  # error do
  #   erb :error
  # end
end