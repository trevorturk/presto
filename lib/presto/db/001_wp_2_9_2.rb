class WP292 < ActiveRecord::Migration
  def self.up
    create_table "wp_commentmeta", :primary_key => "meta_id", :force => true do |t|
      t.integer "comment_id", :limit => 8,          :default => 0, :null => false
      t.string  "meta_key"
      t.text    "meta_value", :limit => 2147483647
    end

    add_index "wp_commentmeta", ["comment_id"], :name => "comment_id"
    add_index "wp_commentmeta", ["meta_key"], :name => "meta_key"

    create_table "wp_comments", :primary_key => "comment_ID", :force => true do |t|
      t.integer  "comment_post_ID",      :limit => 8,   :default => 0,   :null => false
      t.text     "comment_author",       :limit => 255,                  :null => false
      t.string   "comment_author_email", :limit => 100, :default => "",  :null => false
      t.string   "comment_author_url",   :limit => 200, :default => "",  :null => false
      t.string   "comment_author_IP",    :limit => 100, :default => "",  :null => false
      t.datetime "comment_date",                                         :null => false
      t.datetime "comment_date_gmt",                                     :null => false
      t.text     "comment_content",                                      :null => false
      t.integer  "comment_karma",                       :default => 0,   :null => false
      t.string   "comment_approved",     :limit => 20,  :default => "1", :null => false
      t.string   "comment_agent",                       :default => "",  :null => false
      t.string   "comment_type",         :limit => 20,  :default => "",  :null => false
      t.integer  "comment_parent",       :limit => 8,   :default => 0,   :null => false
      t.integer  "user_id",              :limit => 8,   :default => 0,   :null => false
    end

    add_index "wp_comments", ["comment_approved", "comment_date_gmt"], :name => "comment_approved_date_gmt"
    add_index "wp_comments", ["comment_approved"], :name => "comment_approved"
    add_index "wp_comments", ["comment_date_gmt"], :name => "comment_date_gmt"
    add_index "wp_comments", ["comment_post_ID"], :name => "comment_post_ID"

    create_table "wp_links", :primary_key => "link_id", :force => true do |t|
      t.string   "link_url",                             :default => "",  :null => false
      t.string   "link_name",                            :default => "",  :null => false
      t.string   "link_image",                           :default => "",  :null => false
      t.string   "link_target",      :limit => 25,       :default => "",  :null => false
      t.string   "link_description",                     :default => "",  :null => false
      t.string   "link_visible",     :limit => 20,       :default => "Y", :null => false
      t.integer  "link_owner",       :limit => 8,        :default => 1,   :null => false
      t.integer  "link_rating",                          :default => 0,   :null => false
      t.datetime "link_updated",                                          :null => false
      t.string   "link_rel",                             :default => "",  :null => false
      t.text     "link_notes",       :limit => 16777215,                  :null => false
      t.string   "link_rss",                             :default => "",  :null => false
    end

    add_index "wp_links", ["link_visible"], :name => "link_visible"

    create_table "wp_options", :primary_key => "option_id", :force => true do |t|
      t.integer "blog_id",                            :default => 0,     :null => false
      t.string  "option_name",  :limit => 64,         :default => "",    :null => false
      t.text    "option_value", :limit => 2147483647,                    :null => false
      t.string  "autoload",     :limit => 20,         :default => "yes", :null => false
    end

    add_index "wp_options", ["option_name"], :name => "option_name", :unique => true

    create_table "wp_postmeta", :primary_key => "meta_id", :force => true do |t|
      t.integer "post_id",    :limit => 8,          :default => 0, :null => false
      t.string  "meta_key"
      t.text    "meta_value", :limit => 2147483647
    end

    add_index "wp_postmeta", ["meta_key"], :name => "meta_key"
    add_index "wp_postmeta", ["post_id"], :name => "post_id"

    create_table "wp_posts", :primary_key => "ID", :force => true do |t|
      t.integer  "post_author",           :limit => 8,          :default => 0,         :null => false
      t.datetime "post_date",                                                          :null => false
      t.datetime "post_date_gmt",                                                      :null => false
      t.text     "post_content",          :limit => 2147483647,                        :null => false
      t.text     "post_title",                                                         :null => false
      t.text     "post_excerpt",                                                       :null => false
      t.string   "post_status",           :limit => 20,         :default => "publish", :null => false
      t.string   "comment_status",        :limit => 20,         :default => "open",    :null => false
      t.string   "ping_status",           :limit => 20,         :default => "open",    :null => false
      t.string   "post_password",         :limit => 20,         :default => "",        :null => false
      t.string   "post_name",             :limit => 200,        :default => "",        :null => false
      t.text     "to_ping",                                                            :null => false
      t.text     "pinged",                                                             :null => false
      t.datetime "post_modified",                                                      :null => false
      t.datetime "post_modified_gmt",                                                  :null => false
      t.text     "post_content_filtered",                                              :null => false
      t.integer  "post_parent",           :limit => 8,          :default => 0,         :null => false
      t.string   "guid",                                        :default => "",        :null => false
      t.integer  "menu_order",                                  :default => 0,         :null => false
      t.string   "post_type",             :limit => 20,         :default => "post",    :null => false
      t.string   "post_mime_type",        :limit => 100,        :default => "",        :null => false
      t.integer  "comment_count",         :limit => 8,          :default => 0,         :null => false
    end

    add_index "wp_posts", ["post_name"], :name => "post_name"
    add_index "wp_posts", ["post_parent"], :name => "post_parent"
    add_index "wp_posts", ["post_type", "post_status", "post_date", "ID"], :name => "type_status_date"

    create_table "wp_term_relationships", :id => false, :force => true do |t|
      t.integer "object_id",        :limit => 8, :default => 0, :null => false
      t.integer "term_taxonomy_id", :limit => 8, :default => 0, :null => false
      t.integer "term_order",                    :default => 0, :null => false
    end

    add_index "wp_term_relationships", ["term_taxonomy_id"], :name => "term_taxonomy_id"

    create_table "wp_term_taxonomy", :primary_key => "term_taxonomy_id", :force => true do |t|
      t.integer "term_id",     :limit => 8,          :default => 0,  :null => false
      t.string  "taxonomy",    :limit => 32,         :default => "", :null => false
      t.text    "description", :limit => 2147483647,                 :null => false
      t.integer "parent",      :limit => 8,          :default => 0,  :null => false
      t.integer "count",       :limit => 8,          :default => 0,  :null => false
    end

    add_index "wp_term_taxonomy", ["taxonomy"], :name => "taxonomy"
    add_index "wp_term_taxonomy", ["term_id", "taxonomy"], :name => "term_id_taxonomy", :unique => true

    create_table "wp_terms", :primary_key => "term_id", :force => true do |t|
      t.string  "name",       :limit => 200, :default => "", :null => false
      t.string  "slug",       :limit => 200, :default => "", :null => false
      t.integer "term_group", :limit => 8,   :default => 0,  :null => false
    end

    add_index "wp_terms", ["name"], :name => "name"
    add_index "wp_terms", ["slug"], :name => "slug", :unique => true

    create_table "wp_usermeta", :primary_key => "umeta_id", :force => true do |t|
      t.integer "user_id",    :limit => 8,          :default => 0, :null => false
      t.string  "meta_key"
      t.text    "meta_value", :limit => 2147483647
    end

    add_index "wp_usermeta", ["meta_key"], :name => "meta_key"
    add_index "wp_usermeta", ["user_id"], :name => "user_id"

    create_table "wp_users", :primary_key => "ID", :force => true do |t|
      t.string   "user_login",          :limit => 60,  :default => "", :null => false
      t.string   "user_pass",           :limit => 64,  :default => "", :null => false
      t.string   "user_nicename",       :limit => 50,  :default => "", :null => false
      t.string   "user_email",          :limit => 100, :default => "", :null => false
      t.string   "user_url",            :limit => 100, :default => "", :null => false
      t.datetime "user_registered",                                    :null => false
      t.string   "user_activation_key", :limit => 60,  :default => "", :null => false
      t.integer  "user_status",                        :default => 0,  :null => false
      t.string   "display_name",        :limit => 250, :default => "", :null => false
    end

    add_index "wp_users", ["user_login"], :name => "user_login_key"
    add_index "wp_users", ["user_nicename"], :name => "user_nicename"
  end

  def self.down
    # n/a
  end
end
