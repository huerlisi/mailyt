class PaginationListLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer
  include I18nRailsHelpers
  
  def html_container(html)
    html += "<span>| Per page</span>" + [per_page_link(25), per_page_link(50), per_page_link(200)].join('')
    html += "<span>| Order by</span>" + [sort_link(:date), sort_link(:subject), sort_link(:name)].join('')
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

  def sort_link(column)
    column = column.to_s
    column_name = ActiveRecord::Base.connection.quote_column_name(column)
    label ||= t_attr(column, Email)

    if column_name == @template.params[:order]
      link = "<em>%s</em>" % label
    else
      link = "<a class='order' href='%s' title='Ascending #{label}'>%s</a>" % [sort_href(column), label]
    end
    
    return link
  end

  def sort_href(column)
    column_name = ActiveRecord::Base.connection.quote_column_name(column.to_s)
    params = @template.params.merge({:order => column_name})
    
    @template.url_for(params)
  end
end
