require 'active_record'

# TODO split these up into separate files

class Post < ActiveRecord::Base
  set_table_name "wp_posts"
  set_primary_key "ID"
  default_scope :conditions => {:post_type => 'post'}
  named_scope :published, :conditions => {:post_status => 'publish'}
  named_scope :recent, :order => 'post_date desc'
  named_scope :limit, lambda { |l| {:limit => l} }

  # TODO maybe there's a better way...?
  def self.find_by_permalink!(params)
    date = "#{params[:year]}-#{params[:month]}-#{params[:day]}"
    all(:conditions => ["post_date > ? and post_date < ? and post_name = ?", "#{date}-00:00:00", "#{date}-24:00:00", params[:post_name]])
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