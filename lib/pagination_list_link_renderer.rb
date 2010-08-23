class PaginationListLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer

  def html_container(html)
    html += "<span>|</span>" + [per_page_link(25), per_page_link(50), per_page_link(200)].join('')
    tag(:div, html, container_attributes)
  end

  def per_page_link(count)
    if count == @template.params[:per_page].to_i
      link = "<em>%s</em>"  % count
    else
      link = "<a class='per_page' href='%s'>%s</a>" % [per_page_href(count), count]
    end
    
    return link
  end

  def per_page_href(count)
    params = @template.params.merge({:per_page => count})
    
    @template.url_for(params)
  end
end
