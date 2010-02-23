module BetterForm
	class Builder < ActionView::Helpers::FormBuilder
		include ActionView::Helpers::TagHelper

		def text_field(method, options = {})
			human_readable_method = generate_human_readable_method(method)
			options[:class] = "better_text_field #{options[:class]}"
			options[:value] = human_readable_method
			options[:title] = human_readable_method
			required = options.delete(:required)
			validated = options.delete(:validated)
			labelled = options.delete(:labelled)
			required_span = label_tag = description_span = ''

			if required == true || (required != false && @template.require_all?)
				options[:class] = "#{options[:class]} better_required_field"
				required_span = generate_required_span
			end

			if validated == true || (validated != false && @template.validate_all?)
				options[:class] = "#{options[:class]} better_validated_field"
			end

			if labelled == true || (labelled != false && @template.label_all?)
				label_tag = generate_label(method, human_readable_method) + tag('br')
				# Set the field's default value to blank
				options[:value] = ''
			end

			if description = options.delete(:description)
				description_span = generate_description(description) + tag('br')
			end

			content_tag_string(:p, label_tag + InstanceTag.new(@object_name, method, self, options.delete(:object)).to_input_field_tag("text", options) + required_span + tag('br') + description_span, { :class => 'better_field'})
		end

		def select(method, choices, options = {}, html_options = {})
			human_readable_method = generate_human_readable_method(method)
			html_options[:class] = "better_select_field #{html_options[:class]}"
			html_options[:title] = human_readable_method
			required = html_options.delete(:required)
			validated = html_options.delete(:validated)
			labelled = html_options.delete(:labelled)
			required_span = label_tag = description_span = ''

			if required == true || (required != false && @template.require_all?)
				html_options[:class] = "#{html_options[:class]} better_required_field"
				required_span = generate_required_span
			end

			if labelled == true || (labelled != false && @template.label_all?)
				label_tag = generate_label(method, human_readable_method) + tag('br')
			else
				# Add a disabled choice describing what the user is selecting
				choices.insert(0, [human_readable_method, nil])
			end

			if description = html_options.delete(:description)
				description_span = generate_description(description) + tag('br')
			end

			content_tag_string(:p, label_tag + InstanceTag.new(@object_name, method, self, options.delete(:object)).to_select_tag(choices, options, html_options) + required_span + tag('br') + description_span, { :class => 'better_field'})
		end

		def check_box(method, options = {}, checked_value = "1", unchecked_value = "0") 
			human_readable_method = generate_human_readable_method(method)
			options[:class] = "better_checkbox_field #{options[:class]}"
			options[:title] = human_readable_method
			required = options.delete(:required)
			validated = options.delete(:validated)
			labelled = options.delete(:labelled)
			required_span = label_tag = description_span = ''

			if required == true || (required != false && @template.require_all?)
				options[:class] = "#{options[:class]} better_required_field"
				required_span = generate_required_span
			end

			if labelled == true || (labelled != false && @template.label_all?)
				label_tag = generate_label(method, human_readable_method)
			end

			if description = options.delete(:description)
				description_span = generate_description(description)
			end

			content_tag_string(:p, InstanceTag.new(@object_name, method, self, options.delete(:object)).to_check_box_tag(options, checked_value, unchecked_value) + label_tag + required_span + tag('br') + description_span, { :class => 'better_field'})
		end

		def submit(value = '', options = {})
			options[:disabled] = true unless options[:disabled] == false
			if value.blank?
				value = (@object.new_record? ? "Create #{@object_name}" : "Save changes")
			end
			super(value, options)
		end

private
		def setup_field(options)
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
