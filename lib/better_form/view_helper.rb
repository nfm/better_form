module BetterForm
	module ViewHelper
		def better_form_for(*args, &block)
			options = args.extract_options!.reverse_merge(:builder => BetterForm::Builder)
			form_for(*(args << options), &block)
		end
	end
end

class ActionView::Base
	include BetterForm::ViewHelper
end
