module BetterForm
	module ViewHelper
		def better_form_for(record_or_name_or_array, *args, &proc)
			options = args.extract_options!.reverse_merge(:builder => BetterForm::Builder)
			if options[:html] && options[:html][:class]
				options[:html][:class] += " better_form"
			else
				options[:html] ||= {}
				options[:html][:class] = "better_form"
			end

			case record_or_name_or_array
			when String, Symbol
				object_name = record_or_name_or_array
			when Array
				object = record_or_name_or_array.last
				object_name = ActionController::RecordIdentifier.singular_class_name(object)
			else
				object = record_or_name_or_array
				object_name = ActionController::RecordIdentifier.singular_class_name(object)
			end
			options[:html]['data-model-name'] = object_name

			@require_all = options[:require_all]
			@require_all = nil if (@require_all != true && @require_all != false)
			@validate_all = options[:validate_all]
			@validate_all = nil if (@validate_all != true && @validate_all != false)
			@label_all = options[:label_all]
			@label_all = nil if (@label_all != true && @label_all != false)
			form_for(record_or_name_or_array, *(args << options), &proc)
		end

		def require_all?
			@require_all end

		def validate_all?
			@validate_all
		end

		def label_all?
			@label_all
		end
	end
end

class ActionView::Base
	include BetterForm::ViewHelper
end
