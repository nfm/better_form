module BetterForm
	class Builder < ActionView::Helpers::FormBuilder
		include ActionView::Helpers::TagHelper

		cattr_accessor :require_all
		self.require_all = false

		cattr_accessor :validate_all
		self.validate_all = false

		cattr_accessor :label_all
		self.label_all = false

		def text_field(method, options = {})
			setup_field(method, options)

			if validated_field?
				options[:class] += " better_validated_field"
			end

			if labelled_field?
				@label_tag = generate_label(method) + tag('br')
			else
				# Set the field's default value
				options[:value] = @human_readable_method
			end

			generate_field { @label_tag + @instance_tag.to_input_field_tag("text", options) + @required_span + @description_span }
		end

		def select(method, choices, options = {}, html_options = {})
			setup_field(method, html_options)

			if labelled_field?
				@label_tag = generate_label(method) + tag('br')
			else
				# Add a disabled choice describing what the user is selecting
				choices.insert(0, [@human_readable_method, nil])
			end

			generate_field { @label_tag + @instance_tag.to_select_tag(choices, options, html_options) + @required_span + @description_span }
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

		def password_field(method, options = {})
			setup_field(method, options)

			if validated_field?
				options[:class] += " better_validated_field"
			end

			# Always generate a label for password fields unless explicitly told not to
			unless @label == false
				@label_tag = generate_label(method) + tag('br')
			end

			generate_field { @label_tag + @instance_tag.to_input_field_tag("password", options) + @required_span + @description_span }
		end

		def text_area(method, options = {})
			setup_field(method, options)

			if validated_field?
				options[:class] += " better_validated_field"
			end

			if labelled_field?
				@label_tag = generate_label(method) + tag('br')
			else
				# Set the field's default value
				options[:value] = @human_readable_method
			end

			generate_field { @label_tag + @instance_tag.to_text_area_tag(options) + @required_span + @description_span }
		end

		def file_field(method, options = {})
			setup_field(method, options)

			# Always generate a label for file fields unless explicitly told not to
			unless @label == false
				@label_tag = generate_label(method) + tag('br')
			end

			generate_field { @label_tag + @instance_tag.to_input_field_tag("file", options) + @required_span + @description_span }
		end

		def submit(value = '', options = {})
			options[:disabled] = true unless options[:disabled] == false
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

			if described_field?
				@description_span = generate_description(@description)
			end

			@instance_tag = InstanceTag.new(@object_name, method, self, options.delete(:object))
		end

		def generate_field
			field_specific_output = yield
			content_tag_string(:p, field_specific_output, { :class => 'better_field'})
		end

		def required_field?
			true if (@required == true || (@required != false && @template.require_all?) || (@required != false && @template.required_all != false && self.require_all))
		end

		def validated_field?
			true if (@validated == true || (@validated != false && @template.validate_all?) || (@validated != false && @template.validate_all? != false && self.validate_all))
		end

		def labelled_field?
			# If :labelled => true
			if @label == true
				@label = @human_readable_method
				return true
			# If options[:labelled] contained text for the label
			elsif @label.blank? == false
				return true
			elsif ((@label != false && @template.label_all?) || (@label != false && @template.label_all != false && self.label_all))
				@label = @human_readable_method
				return true
			end
			false
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
			label(method, @label, :class => 'better_label')
		end

		def generate_description(description)
			content_tag_string(:span, description, { :class => 'better_described_field' })
		end
	end

	class InstanceTag < ActionView::Helpers::InstanceTag
	end
end
