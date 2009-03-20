class Uberkit::Forms::Builder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  include Strongbits::Helpers::TooltipHelper
  
  helpers = field_helpers + %w(date_select datetime_select time_select select html_area state_select country_select) - %w(hidden_field label fields_for) 
  
  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.extract_options!
      class_names = array_from_classes(options[:class])
      class_names << name
      options[:class] = class_names.join(" ")
      args << options
      generic_field(options[:label],
                    field,
                    super(field,*args),
                    {:description => options.delete(:description), 
                     :help => options.delete(:help), 
                     :required => options.delete(:required),
                     :tooltip => options.delete(:tooltip)})
    end
  end
  
  def generic_field(label_text,field,content,options = {})
    required = options.delete(:required)
    content_tag(:div, :class => "field_row#{' required' if required}#{' labelless' if label_text == ""}") do
      ret = label(field, (label_text || field.to_s.titleize).to_s + ":") unless label_text == ""
      if options[:tooltip]
        ret << build_tt_image(build_tt(field.to_s))
        ret << build_tt_container(field.to_s, options[:tooltip])
      end
      ret << '<br/>'
      ret << content
      ret << content_tag(:span, options.delete(:help), :class => "help") if options[:help]
      ret << content_tag(:span, options.delete(:description), :class => "description") if options[:description]
      ret << "<br/>"
      ret
    end
  end
  
  def submit(text)
    "<div class='button_holder'>" + 
    content_tag(:button, text, :type => "submit") +
    "</div>"
  end
  
  def custom(options = {}, &block)    
    concat("<div class='field_row#{' labelless' unless options[:label]}'>#{"<label#{" for='#{options[:for]}'" if options[:for]}>#{options[:label] + ":" if options[:label]}</label>" if options[:label]}#{build_tt_image(build_tt(options[:label])) if options[:tooltip]}<div class='pseudo_field'>")
    concat("#{build_tt_container(options[:label], options[:tooltip])}") if options[:tooltip]
    yield
    concat("</div> </div>")
  end 
  
  def array_from_classes(html_classes)
    html_classes ? html_classes.split(" ") : []
  end
  
  def fieldset(legend=nil,&block)
    concat("<fieldset>#{"<legend>#{legend}</legend>" if legend}",block.binding)
    yield
    concat("</fieldset>",block.binding)
  end
  
  def output_buffer
    @template.output_buffer
  end
  
  def output_buffer=(buf)
    @template.output_buffer = buf
  end
  
  def is_haml?; false end
end