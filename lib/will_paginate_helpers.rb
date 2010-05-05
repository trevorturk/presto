# TODO is there a better way?

require 'will_paginate'

module WillPaginateHelpers
  def paginate(items, opts={})
    if items.respond_to?(:total_pages)
      html =  "<div class=\"pagination\">"
      html << "<div class=\"next_page#{' disabled' unless @posts.next_page}\"><a href=\"/?page=#{@posts.next_page}\">&laquo; Older posts</a></div>"
      html << "<div class=\"prev_page#{' disabled' unless @posts.previous_page}\"><a href=\"/?page=#{@posts.previous_page}\">Newer posts &raquo;</a></div>"
      html << "</div>"
      html
    end
  end
end