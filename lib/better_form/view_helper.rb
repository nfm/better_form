module BetterForm
	module ViewHelper
		def better_form_for(*args, &block)
			options = args.extract_options!.reverse_merge(:builder => BetterForm::Builder)
			form_for(*(args << options), &block)
			@template.concat(better_form_stylesheet)
		end

		private
			def better_form_stylesheet
				css = content_tag('style', <<-EOT, :type => Mime::CSS)
					input.better_text_field {
						border-top: 1px solid #999;
						border-left: 1px solid #999;
						border-bottom: 1px solid #DDD;
						border-right: 1px solid #DDD;
						color: #AAA;
						margin-bottom: 10px
					}

					input.better_completed_field {
						border: 1px solid #666;
						color: #333;
					}

					input.better_text_field:focus {
						border: 1px solid #666;
						color: #333;
						background-color: #FDFFCF;
					}
				EOT
				return css
			end
	end
end

class ActionView::Base
	include BetterForm::ViewHelper
end
