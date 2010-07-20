module BetterForm
	class Builder < ActionView::Helpers::FormBuilder
		include ActionView::Helpers::TagHelper

		cattr_accessor :require_all
		cattr_accessor :validate_all
		cattr_accessor :label_all

		def text_field(method, options = {})
			setup_field(method, options)

			if labelled_field?
				@label_tag = generate_label(method)
				generate_field { @label_tag + @required_span + @instance_tag.to_input_field_tag("text", options) + tag('br') + @description_span }
			else
				# Set the field's default value if @object is a new empty record
				options[:value] = @human_readable_method if @object.new_record?
				options[:placeholder] = @human_readable_method if @object.new_record?
				generate_field { @instance_tag.to_input_field_tag("text", options) + @required_span + @description_span }
			end
		end

		def select(method, choices, options = {}, html_options = {})
			setup_field(method, html_options)

			if labelled_field?
				@label_tag = generate_label(method)
				generate_field { @label_tag + @required_span + @instance_tag.to_select_tag(choices, options, html_options) + tag('br') + @description_span }
			else
				# Add a disabled choice describing what the user is selecting
				choices.insert(0, [@human_readable_method, nil])
				generate_field { @instance_tag.to_select_tag(choices, options, html_options) + @required_span + @description_span }
			end
		end

		def check_box(method, options = {}, checked_value = "1", unchecked_value = "0") 
			setup_field(method, options)

			if labelled_field?
				@label_tag = generate_label(method)
			end

			generate_field { @instance_tag.to_check_box_tag(options, checked_value, unchecked_value) + @label_tag + @required_span + @description_span }
		end

		def radio_button(method, tag_value, options = {})
			setup_field(method, options)

			# Always generate a label for radio buttons unless explicitly told not to
			unless @label == false
				@label_tag = generate_label(tag_value)
			end

			generate_field { @instance_tag.to_radio_button_tag(tag_value, options) + @label_tag + @required_span + @description_span }
		end

		def radio_buttons(method, options = {}, html_options = {})
			setup_field(method, html_options)

			# Always generate a label for radio buttons unless explicitly told not to
			unless @label == false
				@label_tag = generate_label(method)
			end

			radio_buttons = ""
			options.each do |option|
				radio_buttons += @instance_tag.to_radio_button_tag(option, html_options) + label("#{method}_#{option}", generate_human_readable_method(option), :class => 'better_radio_button_label') + tag('br')
			end

			generate_field { @label_tag + @required_span + @description_span + tag('br') + radio_buttons }
		end

		def password_field(method, options = {})
			setup_field(method, options)

			# Always generate a label for password fields unless explicitly told not to
			unless @label == false
				@label_tag = generate_label(method)
				generate_field { @label_tag + @required_span + @instance_tag.to_input_field_tag("password", options) + tag('br') + @description_span }
			else
				generate_field { @instance_tag.to_input_field_tag("password", options) + @required_span + @description_span }
			end
		end

		def text_area(method, options = {})
			setup_field(method, options)

			if labelled_field?
				@label_tag = generate_label(method)
				generate_field { @label_tag + @required_span + @instance_tag.to_text_area_tag(options) + tag('br') + @description_span }
			else
				# Set the field's default value if @object is a new empty record
				options[:value] = @human_readable_method if @object.new_record?
				options[:placeholder] = @human_readable_method if @object.new_record?
				generate_field { @instance_tag.to_text_area_tag(options) + @required_span + @description_span }
			end
		end

		def file_field(method, options = {})
			setup_field(method, options)

			# Always generate a label for file fields unless explicitly told not to
			unless @label == false
				@label_tag = generate_label(method)
				generate_field { @label_tag + @required_span + @instance_tag.to_input_field_tag("file", options) + tag('br') + @description_span }
			else
				generate_field { @instance_tag.to_input_field_tag("file", options) + @required_span + @description_span }
			end
		end

		def submit(value = '', options = {})
			if value.blank?
				value = (@object.new_record? ? "Create #{@object_name}" : "Save changes")
			end
			super(value, options)
		end

private
		def setup_field(method, options)
			@human_readable_method = generate_human_readable_method(method)
			@required_span = @label_tag = @description_span = ''
			@required = options.delete(:required)
			@validated = options.delete(:validated)
			@label = options.delete(:label)
			@description = options.delete(:description)

			options[:class] ||= ''
			options[:class] += " better_text_field"
			options[:title] = @human_readable_method

			if required_field?
				options[:class] += " better_required_field"
				@required_span = generate_required_span + tag('br')
			else
				@required_span = tag('br')
			end

			if validated_field?
				options[:class] += " better_validated_field"
			end

			if described_field?
				@description_span = generate_description(@description)
			end

			# Set custom HTML5 data- attributes to store:
			# 1. The ajax validation URL associated with this form field
			# 2. The model associated with this form field
			# 2. The model's attribute associated with this form field
			object = ActionController::RecordIdentifier.singular_class_name(@object)
			options['data-ajax-validation-url'] = "/better_ajax_validation/ajax_validate_attribute"
			options['data-model-name'] = object
			options['data-attribute-name'] = method

			options = objectify_options(options)

			@instance_tag = InstanceTag.new(@object_name, method, self, options.delete(:object))
		end

		def generate_field
			field_specific_output = yield
			content_tag_string(:p, field_specific_output, { :class => 'better_field'})
		end

		def required_field?
			true if (@required == true || (@required != false && @template.require_all?) || (@required != false && @template.require_all? != false && self.require_all))
		end

		def validated_field?
			true if (@validated == true || (@validated != false && @template.validate_all?) || (@validated != false && @template.validate_all? != false && self.validate_all))
		end

		def labelled_field?
			# True if the field option :label => true or :label => 'text' or the form or application level option :label_all is true
			true if ((@label == true) || (@label.is_a? String) || (@label != false && @template.label_all?) || (@label != false && @template.label_all? != false && self.label_all))
		end

		def described_field?
			true unless @description.blank?
		end

		def generate_human_readable_method(method)
			method.to_s.gsub(/_/, " ").capitalize
		end

		def generate_required_span
			content_tag_string(:span, "*", { :class => 'better_required_field' })
		end

		def generate_label(method)
			# If :label => true, use @human_readable_method as the label text
			if @label == true
				label(method, @human_readable_method, :class => 'better_label')
			# Else use @label's assigned value
			else
				label(method, @label, :class => 'better_label')
			end
		end

		def generate_description(description)
			content_tag_string(:span, description, { :class => 'better_described_field' })
		end
	end

	class InstanceTag < ActionView::Helpers::InstanceTag
	end
end
