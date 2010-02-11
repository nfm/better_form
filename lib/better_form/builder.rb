module BetterForm
	class Builder < ActionView::Helpers::FormBuilder
		include ActionView::Helpers::TagHelper

		def text_field(method, options = {})
			human_readable_method = method.to_s.gsub(/_/, " ").capitalize
			options[:class] = "better_text_field #{options[:class]}"
			options[:value] = human_readable_method
			options[:title] = human_readable_method

			if options.delete(:required) || @template.require_all?
				options[:class] = "#{options[:class]} better_required_field"
				required_span = content_tag_string(:span, "&nbsp;&#42;", { :class => 'better_required_field' })
			end

			if options.delete(:validated) || @template.validate_all?
				options[:class] = "#{options[:class]} better_validated_field"
			end

			if options.delete(:labelled) || @template.label_all?
				label = label(method, human_readable_method, :class => 'better_label') + tag('br')
				# Set the field's default value to blank
				options[:value] = ''
			end

			(label ||= '') + InstanceTag.new(@object_name, method, self, options.delete(:object)).to_input_field_tag("text", options) + (required_span ||= '') + tag('br')
		end

		def submit(value = '', options = {})
			options[:disabled] = true unless options[:disabled] == false
			if value.blank?
				value = (@object.new_record? ? "Create #{@object_name}" : "Save changes")
			end
			super(value, options)
		end
	end

	class InstanceTag < ActionView::Helpers::InstanceTag
	end
end
