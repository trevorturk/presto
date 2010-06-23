require 'sinatra/base'
require 'sinatra/activerecord'
require 'lib/presto/models'

class Presto::Admin < Sinatra::Base
  set :raise_errors, true
  set :public, './public/admin'
  set :views, './public/admin'

  if ENV['RACK_ENV'] == 'production'
    raise 'no user/pass' unless ENV['presto_user'] && ENV['presto_pass']
    use Rack::Auth::Basic do |user, pass|
      [user, pass] == [ENV['presto_user'], ENV['presto_pass']]
    end
  end

  before do
    @options = Presto::Option.get_all
  end

  get '/' do
    @posts = Presto::Post.published.recent.all(:limit => 10)
    erb :index
  end

  post '/posts' do
    Presto::Post.create!(:post_author => params[:post_author], :post_title => params[:post_title], :post_content => params[:post_content])
    redirect back
  end

  get '/posts/edit/:id' do
    @post = Presto::Post.find(params[:id])
    erb :show
  end

  post '/posts/edit/' do
    @post = Presto::Post.find(params[:post_id])
    @post.post_author = params[:post_author]
    @post.post_title = params[:post_title]
    @post.post_content = params[:post_content]
    @post.save!
    redirect '/presto/'
  end

  post '/posts/destroy/:id' do
    Presto::Post.find(params[:id]).destroy
    redirect back
  end
end