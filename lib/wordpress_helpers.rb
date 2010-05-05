require 'digest/md5' # for gravatars

# TODO figure out how to not extend String with these methods
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

module WordPressHelpers

  # TODO move this stuff into separate files

  # general TODO move

  def gravatar_url_for(email)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}"
  end

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

  # conditional tags
  # http://codex.wordpress.org/Conditional_Tags

  # TODO take all the params they take
  def is_single?
    @posts.size == 1 # TODO this won't work if blog only showing 1 item...
  end

  # formatting
  # via http://codex.wordpress.org/How_WordPress_Processes_Post_Content

  # The default handling of posts/the_content is: wptexturize,
  # convert_smilies, convert_chars, wpautop, shortcode_unautop,
  # prepend_attachment... but we're only doing wpautop (for now)

  def wp_format(str)
    wpautop(str)
  end

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