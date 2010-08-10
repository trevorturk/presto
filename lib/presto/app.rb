require 'sinatra/base'
require 'sinatra/activerecord'
require 'lib/presto/models'
require 'lib/presto/helpers'

class Presto::App < Sinatra::Base
  set :raise_errors, true
  set :public, './public'
  set :views, './public/themes/trevorturk'

  helpers Presto::Helpers

  before do
    @options = Presto::Option.get_all
    redirect '/?not_found=1', 302 if params[:page] && params[:page].to_i == 0 # catch bogus page #s
  end

  get '/' do
    @posts = Presto::Post.published.recent.all.paginate(:page => params[:page], :per_page => @options['posts_per_page'])
    erb :index
  end

  get '/:y/:m/:d/:slug/' do
    @posts = Presto::Post.published.find_by_ymd_and_slug!(params).to_a
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

  get '/resume/' do
    erb :resume
  end

  get '/hoptoad/' do
    raise "Kaboom!"
  end

  not_found do
    redirect '/?not_found=1', 302
  end
end