module BetterForm
	class Builder < ActionView::Helpers::FormBuilder
		def text_field(object_name, method, options = {})
			InstanceTag.new(object_name, method, self, options.delete(:object)).to_label_tag("#{method}:", options)
			InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("text", options)
		end
	end
end
