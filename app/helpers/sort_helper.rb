module SortHelper
  include I18nRailsHelpers
  
  def sort_header(column, label = nil)
    label ||= t_attr(column)
    column_name = ActiveRecord::Base.connection.quote_column_name(column.to_s)
    asc_link = link_to(image_tag('16x16/up.png'), params.merge(:order => column_name + ' DESC'))
    desc_link = link_to(image_tag('16x16/down.png'), params.merge(:order => column_name))
    
    content_tag('th', h(label) + ' '.html_safe + asc_link + desc_link, :class => column)
  end

  def sort_link(column, label = nil)
    label ||= t_attr(column)
    column_name = ActiveRecord::Base.connection.quote_column_name(column.to_s)
    asc_link = link_to(image_tag('16x16/up.png'), params.merge(:order => column_name + ' DESC'))
    desc_link = link_to(image_tag('16x16/down.png'), params.merge(:order => column_name))
    
    content_tag('span', h(label) + ' '.html_safe + asc_link + desc_link, :class => column)
  end
end
