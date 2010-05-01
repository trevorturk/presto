class Post < ActiveRecord::Base
  set_table_name "wp_posts"
  set_primary_key "ID"
  default_scope :conditions => {:post_type => 'post'}
  named_scope :published, :conditions => {:post_status => 'publish'}
  named_scope :recent, :order => 'post_date desc'
  named_scope :limit, lambda { |l| {:limit => l} }
end

class Page < Post
  default_scope :conditions => {:post_type => 'page'}
  named_scope :published, :conditions => {:post_status => 'publish'}
end

class Option < ActiveRecord::Base
  set_table_name "wp_options"
  set_primary_key "option_id"
end