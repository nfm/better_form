module BetterForm
	module ViewHelper
		def better_form_for(record_or_name_or_array, *args, &proc)
			options = args.extract_options!.reverse_merge(:builder => BetterForm::Builder)
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
