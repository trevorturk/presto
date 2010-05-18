require 'active_record'
require 'will_paginate'

# http://codex.wordpress.org/Database_Description
module Presto
  class Comment < ActiveRecord::Base
    set_table_name "wp_comments"
    set_primary_key 'comment_ID'
    named_scope :approved, :conditions => {:comment_approved => '1'}
  end

  # class Category < ActiveRecord::Base
  #   set_table_name "wp_terms"
  #   set_primary_key 'term_id'
  #
  #   # polymorphic :( -- object_id can refer to a post or a link
  #   default_scope :joins => :term_taxonomy, :conditions => "wp_term_taxonomy.taxonomy = 'category'"
  #
  #   has_one :term_taxonomy, :foreign_key => 'term_id'
  #   has_many :term_relationships, :foreign_key => 'term_taxonomy_id'
  #   has_many :posts, :through => :term_relationships, :foreign_key => 'term_taxonomy_id'
  #
  #   def self.default
  #     id = Option.get('default_category')
  #     find(id)
  #   end
  # end

  class Option < ActiveRecord::Base
    set_table_name "wp_options"
    set_primary_key 'option_id'

    def self.get(option_name)
      find_by_option_name!(option_name).option_value
    end

    def self.set(option_name, option_value)
      find_or_create_by_option_name(option_name).update_attribute('option_value', option_value)
    end

    def self.get_all
      @options = {}
      opts = all
      opts.each { |opt| @options[opt.option_name] = opt.option_value }
      @options
    end
  end

  class Post < ActiveRecord::Base
    set_table_name "wp_posts"
    set_primary_key 'ID'
    default_scope :conditions => {:post_type => 'post'}
    named_scope :published, :conditions => {:post_status => 'publish'}
    named_scope :recent, :order => 'post_date desc'

    belongs_to :user, :foreign_key => 'post_author'
    # has_many :term_relationships, :foreign_key => 'object_id' # note object_id may refer to a link, too
    # has_many :categories, :through => :term_relationships

    validates_presence_of :post_author, :post_title, :post_content
    before_validation_on_create :set_default_attributes
    before_create :manually_autoincrement_id
    # after_create :add_to_default_category
    # after_destroy :remove_from_default_category

    def manually_autoincrement_id
      # no idea why this is necessary
      # ActiveRecord::StatementInvalid: PGError: ERROR:  null value in column "ID" violates not-null constraint
      self.ID = Presto::Post.recent.first.ID.to_i + 1
    end

    def set_default_attributes
      self.post_name = Utils.parameterize(self.post_title)
      self.post_date = self.post_date_gmt = self.post_modified = self.post_modified_gmt = Time.now.utc
      self.guid = self.to_url
      # hacks for :null => false in db schema
      self.post_excerpt = self.post_password = self.to_ping = self.pinged = self.post_content_filtered = self.post_mime_type = ''
      self.post_parent = 0
    end

    # def add_to_default_category
    #   default_category = Category.default
    #   self.categories << default_category
    #   default_category.term_taxonomy.increment!(:count)
    # end

    # def remove_from_default_category
    #   self.categories = [] # doing it manually, but shoudn't have to...?
    #   self.save
    #   default_category = Category.default
    #   default_category.term_taxonomy.decrement!(:count)
    # end

    def self.find_by_ymd_and_slug!(params)
      date = "#{params[:y].to_i}-#{params[:m].to_i}-#{params[:d].to_i}"
      raise Sinatra::NotFound if date.split('-').include?('0')
      post = first(:conditions => ["post_date > ? and post_date < ? and post_name = ?", "#{date} 00:00:00", "#{date} 24:00:00", params[:slug]])
      raise Sinatra::NotFound unless post
      post
    end

    def to_param
      "#{post_date.year}/#{post_date.month}/#{post_date.day}/#{post_name}/"
    end

    def to_url
      "#{Option.get('home').chomp('/')}/#{to_param}"
    end

    def to_s
      post_title
    end
  end

  # class Page < Post
  #   default_scope :conditions => {:post_type => 'page'}
  #   named_scope :published, :conditions => {:post_status => 'publish'}
  # end

  # class TermRelationship < ActiveRecord::Base
  #   set_table_name "wp_term_relationships"
  #   set_primary_key nil
  #
  #   belongs_to :category, :foreign_key => 'term_taxonomy_id'
  #   belongs_to :post, :foreign_key => 'object_id'
  # end

  # class TermTaxonomy < ActiveRecord::Base
  #   set_table_name "wp_term_taxonomy"
  #   set_primary_key 'term_taxonomy_id'
  #
  #   belongs_to :category, :foreign_key => 'term_id'
  # end

  class User < ActiveRecord::Base
    set_table_name "wp_users"
    set_primary_key 'ID'

    # has_many :posts, :foreign_key => 'post_author'
    # has_many :pages, :foreign_key => 'post_author'
  end

  module Utils
    # http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html
    def self.parameterize(string, sep = '-')
      # parameterized_string = transliterate(string)
      # parameterized_string.gsub!(/[^a-z0-9\-_\+]+/i, sep)
      parameterized_string = string.gsub(/[^a-z0-9\-_\+]+/i, sep)
      unless sep.blank?
        re_sep = Regexp.escape(sep)
        parameterized_string.gsub!(/#{re_sep}{2,}/, sep)
        parameterized_string.gsub!(/^#{re_sep}|#{re_sep}$/i, '')
      end
      parameterized_string.downcase
    end
  end
end