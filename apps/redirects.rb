class Redirects < Sinatra::Base
  get '/click/' do
    redirect 'http://clickthatbutton.com/', 301
  end

  get '/eldorado/' do
    redirect 'http://github.com/trevorturk/eldorado/', 301
  end

  get '/flowcoder/' do
    redirect 'http://flowcoder.com/', 301
  end

  get '/h8ter/' do
    redirect 'http://h8ter.org/', 301
  end

  get '/kzak/' do
    redirect 'http://github.com/trevorturk/kzak/', 301
  end

  get '/pygments/' do
    redirect 'http://pygments.appspot.com/', 301
  end

  get '/reelroulette/' do
    redirect 'http://reelroulette.net/', 301
  end

  get '/static/' do
    redirect 'http://github.com/trevorturk/static/', 301
  end

  get '/wordpress/' do
    redirect 'http://wordpress.org/extend/plugins/profile/trevorturk/', 301
  end
end