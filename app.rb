require 'sinatra/base'
require 'erubis'

require 'lib/models/active_record'
require 'lib/helpers/wordpress'

class App < Sinatra::Base

  helpers WordPressHelpers

  configure do
    set :public, File.dirname(__FILE__) + '/public'
    set :views, File.dirname(__FILE__) + '/public/themes/trevorturk'
    set :logging, true

    dbconfig = YAML.load(File.read('config/database.yml'))
    ActiveRecord::Base.establish_connection dbconfig[ENV['RACK_ENV']]
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  before do
    @options = Option.get_all # e.g. <%= @options['blogname'] %>
  end

  get '/' do
    if params[:p]
      @posts = Post.published.find(params[:p]).to_a
      erubis :index # TODO prefer single.erubis
    else
      @posts = Post.published.recent.limit(@options['posts_per_page'])
      erubis :index
    end
  end

  # common wp post routes:
  # default: /?p=123 (above)
  # day and name: /2010/05/04/sample-post/ (below)
  # month and name: /2010/05/sample-post/ (TODO)
  # numeric: /archives/123 (TODO)

  get '/:year/:month/:day/:post_name/' do
    @posts = Post.published.find_by_permalink!(params).to_a
    erubis :index # TODO prefer single.erubis
  end

  # TODO not found and errors

  # not_found do
  #   erubis :not_found
  # end

  # error do
  #   erubis :error
  # end

  # custom redirects

  get '/click' do
    redirect 'http://clickthatbutton.com', 301
  end

  get '/eldorado' do
    redirect 'http://github.com/trevorturk/eldorado', 301
  end

  get '/flowcoder' do
    redirect 'http://flowcoder.com', 301
  end

  get '/h8ter' do
    redirect 'http://h8ter.org', 301
  end

  get '/kzak' do
    redirect 'http://github.com/trevorturk/kzak', 301
  end

  get '/pygments' do
    redirect 'http://pygments.appspot.com', 301
  end

  get '/reelroulette' do
    redirect 'http://reelroulette.net', 301
  end

  get '/static' do
    redirect 'http://github.com/trevorturk/static', 301
  end

  get '/wordpress' do
    redirect 'http://wordpress.org/extend/plugins/profile/trevorturk', 301
  end
end