require 'digest/md5' # gravatar_url_for

class String
  def wp_stripslashes
    self.gsub(/\\(\'|\"|\\)/, '\1')
  end

  def wp_cleanpre
    tmp = self
    tmp = tmp.gsub('<br />','')
    tmp = tmp.gsub(/<p>/, "\n")
    tmp.gsub('</p>','')
  end
end

module Presto
  module Helpers

    # http://stackoverflow.com/questions/2520546/sinatra-partial-with-data
    def partial(template, locals = {})
      erb(template, :layout => false, :locals => locals)
    end

    # http://github.com/lenary/ginatra/blob/master/lib/ginatra/helpers.rb
    def simple_format(text)
      text.gsub!(/ +/, " ")
      text.gsub!(/\r\n?/, "\n")
      text.gsub!(/\n/, "<br />\n")
      text
    end

    # http://en.gravatar.com/site/implement/ruby
    def gravatar_url_for(email)
      "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}"
    end

    # will_paginate
    def paginate(items, opts={})
      if items.respond_to?(:total_pages)
        html =  "<div class=\"pagination\">"
        html << "<div class=\"next_page#{' disabled' unless @posts.next_page}\"><a href=\"/?page=#{@posts.next_page}\">&laquo; Older posts</a></div>"
        html << "<div class=\"prev_page#{' disabled' unless @posts.previous_page}\"><a href=\"/?page=#{@posts.previous_page}\">Newer posts &raquo;</a></div>"
        html << "</div>"
        html
      end
    end

    # http://codex.wordpress.org/Conditional_Tags
    def is_single?
      @posts.size == 1
    end

    def wp_format(str)
      wpautop(str)
    end

    # via http://codex.wordpress.org/How_WordPress_Processes_Post_Content
    def wpautop(pee, br=true)
    	pee = pee + "\n\n" # just to make things a little easier, pad the end
    	pee = pee.gsub(/<br \/>\s*<br \/>/, "\n\n")
    	# Space things out a little
    	allblocks = /(?:table|thead|tfoot|caption|colgroup|tbody|tr|td|th|div|dl|dd|dt|ul|ol|li|pre|select|form|blockquote|address|math|style|script|object|input|param|p|h[1-6])/
    	pee = pee.gsub(/(<#{allblocks}[^>]*>)/, "\n\\1")
    	pee = pee.gsub(/(<\/#{allblocks}>)/, "\\1\n\n")
    	pee = pee.gsub("\r\n", "\n").gsub("\r", "\n") # cross-platform newlines
    	pee = pee.gsub(/\n\n+/, "\n\n") # take care of duplicates
    	pee = pee.gsub(/<(script|style)[\000-\377]*?<\/\1>/) { |match| match.gsub("\n", "<WPPreserveNewline />") }
    	pee = pee.gsub(/\n?(.+?)(?:\n\s*\n|\z)/s, "<p>\\1</p>\n") # make paragraphs, including one at the end
    	pee = pee.gsub("<WPPreserveNewline />", "\n")
    	pee = pee.gsub(/<p>\s*?<\/p>/, '') # under certain strange conditions it could create a P of entirely whitespace
    	pee = pee.gsub(/<p>([^<]+)\s*?(<\/(?:div|address|form)[^>]*>)/, "<p>\\1</p>\\2")
    	pee = pee.gsub(/<p>/, "\\1<p>")
    	pee = pee.gsub(/<p>\s*(<\/?#{allblocks}[^>]*>)\s*<\/p>/, "\\1") # don't pee all over a tag
    	pee = pee.gsub(/<p>(<li.+?)<\/p>/, "\\1") # problem with nested lists
    	pee = pee.gsub(/<p><blockquote([^>]*)>/i, "<blockquote\\1><p>")
    	pee = pee.gsub(/<\/blockquote><\/p>/, '</p></blockquote>')
    	pee = pee.gsub(/<p>\s*(<\/?#{allblocks}[^>]*>)/, "\\1")
    	pee = pee.gsub(/(<\/?#{allblocks}[^>]*>)\s*<\/p>/, "\\1")
    	if br
    		pee = pee.gsub(/<(script|style)[\000-\377]*?<\/\1>/) { |match| match.gsub("\n", "<WPPreserveNewline />") }
    		pee = pee.gsub(/<br \/>\s*\n/, "\001")
    		pee = pee.gsub(/\s*\n/, "<br />\n")
    		pee = pee.gsub("\001", "<br />\n")
    		pee = pee.gsub("<WPPreserveNewline />", "\n")
    	end
    	pee = pee.gsub(/(<\/?#{allblocks}[^>]*>)\s*<br \/>/, "\\1")
    	pee = pee.gsub(/<br \/>(\s*<\/?(?:p|li|div|dl|dd|dt|th|pre|td|ul|ol)[^>]*>)/, "\\1")
    	if /<pre/.match(pee)
    	  pee = pee.gsub(/(<pre[^>]*>)([\000-\377]*?)<\/pre>/is) { |match| $1.wp_stripslashes + $2.wp_cleanpre.wp_stripslashes + '</pre>' };
    	end
    	pee.gsub(/\n<\/p>$/, '</p>')
    	pee.chop
    end
  end
end