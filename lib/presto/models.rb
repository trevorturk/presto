module Presto
  class Post < ActiveRecord::Base
    set_table_name "wp_posts"
    set_primary_key "ID"
    default_scope :conditions => {:post_type => 'post'}
    named_scope :published, :conditions => {:post_status => 'publish'}
    named_scope :recent, :order => 'post_date desc'
    has_many :comments,
      :foreign_key => 'comment_post_ID', :order => 'comment_date asc'
    has_many :approved_comments,
      :foreign_key => 'comment_post_ID', :order => 'comment_date asc',
      :class_name => 'Comment', :conditions => {:comment_approved => '1'}

    def self.find_by_permalink!(params)
      date = "#{params[:year]}-#{params[:month]}-#{params[:day]}"
      all(:include => :approved_comments, :conditions =>
      ["post_date > ? and post_date < ? and post_name = ?",
        "#{date} 00:00:00", "#{date} 24:00:00", params[:post_name]])
    end

    def to_param
      "#{post_date.year}/#{post_date.month}/#{post_date.day}/#{post_name}/"
    end

    def to_s
      post_title
    end
  end

  class Page < Post
    default_scope :conditions => {:post_type => 'page'}
    named_scope :published, :conditions => {:post_status => 'publish'}
  end

  class Option < ActiveRecord::Base
    set_table_name "wp_options"
    set_primary_key "option_id"

    def self.get(option_name)
      find_by_option_name!(option_name).option_value
    end

    def self.set(option_name, option_value)
      find_by_option_name!(option_name).update_attribute('option_value', option_value)
    end

    def self.get_all
      @options = {}
      opts = all
      opts.each { |opt| @options[opt.option_name] = opt.option_value }
      @options
    end
  end

  class Comment < ActiveRecord::Base
    set_table_name "wp_comments"
    set_primary_key "comment_ID"
    named_scope :approved, :conditions => {:comment_approved => '1'}
  end
end