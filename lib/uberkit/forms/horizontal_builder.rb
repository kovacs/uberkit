class Uberkit::Forms::HorizontalBuilder < Uberkit::Forms::Builder
  def generic_field(label_text,field,content,options = {})
    required = options.delete(:required)
    content_tag(:tr, :class => "field_row#{' required' if required}#{' labelless' if label_text == ""}") do
      ret = '<td>'
      ret << label(field, (label_text || field.to_s.titleize).to_s + ":") unless label_text == ""
      if options[:tooltip]
        ret << build_tt_image(build_tt(field.to_s))
        ret << build_tt_container(field.to_s, options[:tooltip])
      end
      ret << '</td><td>'
      ret << content
      ret << content_tag(:span, options.delete(:help), :class => "help") if options[:help]
      ret << content_tag(:span, options.delete(:description), :class => "description") if options[:description]
      ret << "</td></tr>"
      ret
    end
  end

  def custom(options = {}, &block)
    concat("<div class='yui-gd field_row'><div class='yui-u first'><label#{" for='#{options[:for]}'" if options[:for]}>#{options[:label] + ":" if options[:label]} </label></div><div class='yui-u'>")
    yield
    concat("</div></div>")
  end

end