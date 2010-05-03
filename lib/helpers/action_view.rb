# via http://api.rubyonrails.org/classes/ActionView/Helpers/TextHelper.html

module ActionViewHelpers
  def simple_format(text, html_options={})
    start_tag = tag('p', html_options, true)
    text = text.to_s.dup
    text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
    text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  -> paragraph
    text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
    text.insert 0, start_tag
    text << "</p>"
  end

  def tag(name, options = nil, open = false, escape = true)
    "<#{name}#{tag_options(options, escape) if options}#{open ? ">" : " />"}"
  end

  def tag_options(options, escape = true)
    unless options.blank?
      attrs = []
      if escape
        options.each_pair do |key, value|
          if BOOLEAN_ATTRIBUTES.include?(key)
            attrs << %(#{key}="#{key}") if value
          else
            attrs << %(#{key}="#{escape_once(value)}") if !value.nil?
          end
        end
      else
        attrs = options.map { |key, value| %(#{key}="#{value}") }
      end
      " #{attrs.sort * ' '}".html_safe! unless attrs.empty?
    end
  end
end