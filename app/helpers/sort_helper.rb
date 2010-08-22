module SortHelper
  include I18nRailsHelpers
  
  def sort_header(column, label = nil)
    label ||= t_attr(column)
    asc_link = link_to(image_tag('16x16/up.png'), params.merge(:order => column.to_s + ' DESC'))
    desc_link = link_to(image_tag('16x16/down.png'), params.merge(:order => column.to_s))
    
    content_tag('th', h(label) + ' '.html_safe + asc_link + desc_link, :class => column)
  end
end
