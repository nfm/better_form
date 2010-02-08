module BetterForm
	class Builder < ActionView::Helpers::FormBuilder
		include ActionView::Helpers::TagHelper

		def text_field(method, options = {})
			human_readable_method = method.to_s.gsub(/_/, " ").capitalize
			options[:class] = "better_text_field #{options[:class]}"
			options[:value] = human_readable_method
			InstanceTag.new(@object_name, method, self, options.delete(:object)).to_input_field_tag("text", options) + tag('br')
		end
	end

	class InstanceTag < ActionView::Helpers::InstanceTag
	end
end
