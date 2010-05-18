namespace :heroku do
  desc "PostgreSQL database backups from Heroku to Amazon S3"
  task :backup do
    begin
      require 'right_aws'
      puts "[#{Time.now}] heroku:backup started"
      name = "#{ENV['APP_NAME']}-#{Time.now.strftime('%Y-%m-%d-%H%M%S')}.dump"
      db = ENV['DATABASE_URL'].match(/postgres:\/\/([^:]+):([^@]+)@([^\/]+)\/(.+)/)
      system "PGPASSWORD=#{db[2]} pg_dump -Fc --username=#{db[1]} --host=#{db[3]} #{db[4]} > tmp/#{name}"
      s3 = RightAws::S3.new(ENV['s3_access_key_id'], ENV['s3_secret_access_key'])
      bucket = s3.bucket("#{ENV['APP_NAME']}-heroku-backups", true, 'private')
      bucket.put(name, open("tmp/#{name}"))
      system "rm tmp/#{name}"
      puts "[#{Time.now}] heroku:backup complete"
    rescue Exception => e
      require 'toadhopper'
      Toadhopper(ENV['hoptoad_key']).post!(e)
    end
  end
end

task :cron do
  Rake::Task['heroku:backup'].invoke
  # Rake::Task['delicious'].invoke if Time.now.wday == 0 # sunday
end

task :delicious do
  require 'rubygems'
  require 'rest_client'
  require 'json'
  require 'pony'

  req = RestClient.get 'http://feeds.delicious.com/v2/json/trevorturk?count=100'
  links = JSON.parse(req.body)
  body = ''

  links.each do |l|
    body << "<p><a href=\"#{l['u']}\">#{l['d']}</a></p>\n"
    body << "<blockquote><p>#{l['n']}</p></blockquote>\n\n"
  end

  puts body

  # Pony.mail(:to => 'trevorturk@gmail.com',
  #   :from => 'weekly-digest@trevorturk.com',
  #   :subject => "Weekly Digest #{Time.now.strftime('%b-%d-%y')}",
  #   :body => body,
  #   :via => :smtp,
  #   :via_options =>
  #   {
  #     :address        => 'smtp.sendgrid.net',
  #     :port           => '25',
  #     :authentication => :plain,
  #     :user_name      => ENV['SENDGRID_USERNAME'],
  #     :password       => ENV['SENDGRID_PASSWORD'],
  #     :domain         => ENV['SENDGRID_DOMAIN']
  #   }
  # )
end