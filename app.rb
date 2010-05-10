require 'sinatra/base'
require 'lib/presto/models'
require 'lib/presto/helpers'

class Presto::App < Sinatra::Base
  set :public, './public'

  helpers Presto::Helpers

  configure do
    dbconfig = YAML.load(File.read('config/database.yml'))
    ActiveRecord::Base.establish_connection dbconfig[ENV['RACK_ENV']]
    ActiveRecord::Base.logger = Logger.new(STDOUT)
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

  get '/feed*' do
    redirect '/feed/', 301 # catch legacy wp feed routes (e.g. /feed/rss2/)
  end

  get '/hoptoad/' do
    raise "Kaboom!"
  end

  not_found do
    redirect '/?not_found=1', 302
  end

  error do
    if ENV['hoptoad_key']
      require 'toadhopper'
      Toadhopper(ENV['hoptoad_key']).post!(env)
    end
    "Sorry, there was an error"
  end
end