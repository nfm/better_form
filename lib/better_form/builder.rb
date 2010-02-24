module BetterForm
	class Builder < ActionView::Helpers::FormBuilder
		include ActionView::Helpers::TagHelper

		def text_field(method, options = {})
			setup_field(method, options)

			if validated_field?
				options[:class] += " better_validated_field"
			end

			if labelled_field?
				@label_tag = generate_label(method, @human_readable_method) + tag('br')
			else
				# Set the field's default value to blank
				options[:value] = @human_readable_method
			end

			content_tag_string(:p, @label_tag + InstanceTag.new(@object_name, method, self, options.delete(:object)).to_input_field_tag("text", options) + @required_span + @description_span, { :class => 'better_field'})
		end

		def select(method, choices, options = {}, html_options = {})
			setup_field(method, html_options)

			if labelled_field?
				@label_tag = generate_label(method, @human_readable_method) + tag('br')
			else
				# Add a disabled choice describing what the user is selecting
				choices.insert(0, [@human_readable_method, nil])
			end

			content_tag_string(:p, @label_tag + InstanceTag.new(@object_name, method, self, options.delete(:object)).to_select_tag(choices, options, html_options) + @required_span + @description_span, { :class => 'better_field'})
		end

		def check_box(method, options = {}, checked_value = "1", unchecked_value = "0") 
			setup_field(method, options)

			if labelled_field?
				@label_tag = generate_label(method, @human_readable_method)
			end

			content_tag_string(:p, InstanceTag.new(@object_name, method, self, options.delete(:object)).to_check_box_tag(options, checked_value, unchecked_value) + @label_tag + @required_span + @description_span, { :class => 'better_field'})
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
			@labelled = options.delete(:labelled)
			@description = options.delete(:description)
			options[:class] += " better_text_field"
			options[:title] = @human_readable_method

			if required_field?
				options[:class] += " better_required_field"
				@required_span = generate_required_span + tag('br')
			end

			if described_field?
				@description_span = generate_description(@description)
			end
		end

		def required_field?
			true if (@required == true || (@required != false && @template.require_all?))
		end

		def validated_field?
			true if (@validated == true || (@validated != false && @template.validate_all?))
		end

		def labelled_field?
			true if (@labelled == true || (@labelled != false && @template.label_all?))
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

		def generate_label(method, name)
			label(method, name, :class => 'better_label')
		end

		def generate_description(description)
			content_tag_string(:span, description, { :class => 'better_described_field' })
		end
	end

	class InstanceTag < ActionView::Helpers::InstanceTag
	end
end
