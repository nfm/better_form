module BetterForm
	class Builder < ActionView::Helpers::FormBuilder
		include ActionView::Helpers::TagHelper

		def text_field(method, options = {})
			human_readable_method = method.to_s.gsub(/_/, " ").capitalize
			options[:class] = "better_text_field #{options[:class]}"
			options[:value] = human_readable_method
			options[:title] = human_readable_method

			if options.delete(:required)
				options[:class] = "#{options[:class]} better_required_field"
				required_span = content_tag_string(:span, "&nbsp;&#42;", { :class => 'better_required_field' })
			end

			if options.delete(:validated)
				options[:class] = "#{options[:class]} better_validated_field"
			end

			InstanceTag.new(@object_name, method, self, options.delete(:object)).to_input_field_tag("text", options) + (required_span ||= '') + tag('br')
		end

		def submit(value = '', options = {})
			super(value || @object.new_record? ? "Create #{@object_name}" : "Save changes", options)
		end
	end

	class InstanceTag < ActionView::Helpers::InstanceTag
	end
end
