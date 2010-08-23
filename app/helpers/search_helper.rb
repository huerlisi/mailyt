module SearchHelper
  def highlight_words(query, selector)
    return unless query.present?

    content = ActiveSupport::SafeBuffer.new
    for word in query
      content += javascript_tag "Element.highlight($('#{selector}'), '#{escape_javascript(word)}', 'match');"
    end

    return content
  end
end
