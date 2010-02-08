module BetterForm
	class Builder < ActionView::Helpers::FormBuilder
		def text_field(object_name, method, options = {})
			human_readable_method = method.to_s.gsub(/_/, " ").capitalize
			text_field = InstanceTag.new(object_name, method, self, options.delete(:object)).to_label_tag("#{human_readable_method}:", options)
			label = InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("text", options)
			return text_field + label
		end
	end

	class InstanceTag < ActionView::Helpers::InstanceTag
	end
end
