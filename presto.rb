require 'sinatra/base'

require 'active_record'
require 'erubis'
require 'wp'

require 'wp_format'

class Presto < Sinatra::Base

  configure do
    set :public, File.dirname(__FILE__) + '/public'
    set :views, File.dirname(__FILE__) + '/public/themes/trevorturk'
    set :logging, true

    dbconfig = YAML.load(File.read('config/database.yml'))
    ActiveRecord::Base.establish_connection dbconfig[ENV['RACK_ENV']]
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  before do
    @options = get_options
  end

  get '/' do
    @posts = Post.published.recent.limit(@options['posts_per_page'])
    erubis :index
  end

  # TODO

  not_found do
    erubis :'404'
  end

  # error do
  #   erubis :error
  # end

  # CUSTOM redirects

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

private

  def get_options
    @options = {}
    opts = Option.all
    opts.each { |opt| @options[opt.option_name] = opt.option_value }
    @options
  end
end