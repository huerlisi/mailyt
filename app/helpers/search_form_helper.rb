module SearchFormHelper
  def search_form_for(object_name, options={}, &block)
    options[:html] = {:method => :get}.update(options[:html] || {})
    object = OpenStruct.new(params[object_name])
    semantic_form_for(object_name, object, options, &block)
  end
end
