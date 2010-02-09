module BetterForm
	module ViewHelper
		def better_form_for(record_or_name_or_array, *args, &proc)
			options = args.extract_options!.reverse_merge(:builder => BetterForm::Builder)
			form_for(record_or_name_or_array, *(args << options), &proc)
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

					span.better_required_field {
						color: #FF4F4F;
					}

					span.better_valid_field, span.better_invalid_field {
						display: inline-block;
						height: 16px;
						width: 16px;
						margin: 0 4px;
					}

					span.better_valid_field {
						background: 0 0 no-repeat url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAKeSURBVDjLpZPrS5NRHMf9O/Zse2yCBDKiEEFCqL0KEok9mg3FvCxL09290jZj2EyLMnJexkgpLbPUanPObOrU5taUMnHZo4SYe9OFasPoYt/OsxczSXxRB75wOJzP53eucQDi/id/DRT6DiXkTR/U53hS2cwn+8PSx+Kw1JXESp1J+gz73oRdBfneNEbmSQnpPDLcDFrQv9wdTddiC0pdxyDpo0OSXprZUUCqMlnjyZGrc0Y4Vwdge3UNprmqaLi+Y7UfTTPVOGATRFJsAmabINeTKspyJ69zMDexNlCOSn8pNDNnoCOpIKnxnYX9zT1cnKqE2MJfF1/ni2ICmTvZoBrLjlbmYA5UeU9BMV0ExVQh1FNFcK8NweBVwkEkeb1HkHiFb4gJMh+L2a5gC6zBZlT6SqB8KidgAZSTJJ4CjL91gWuhyBraXzTBNteE+AY+GxMctSduPFi5jbqABlpvMVnJIBY/zkM1UYSxteEo/HPzB9qfX4JhogT9wS4IjdRGTCC5T28MLPfA6Fehzq/F52+fotCHr+9isGW2AWpXDvTu0xgIdkJY+6egl2ZvzDejY+EydJNymH01iHz/EoU3f23C8uwCyp3Z0BBBa6AeHV4z6Gpqawtpt4QG+WA67Ct3UTMhh9p9EvXTFVh6v4D22UaUDR2HwnECOmcu7K97kGE9DLqK2jrEFKtAtI9cjdmjwUP2DqpG86EdyYVqWAalgwsH5+DRUjeMwyUQqnnrtJoSbXtISc18Jr6Ripjc5XAQSVvADP1oMc6NyNFGtmAnsN5ZDEEZL0JgZsenvKeRz9AmKiTtlKDDb0bfSyv65q2weE1Ib02DUMEL0SqK2fUz0ef5CbSB0tO1FCvU8sJCFS9MKrIkerqM2v0z/Ut+A2fQrOU2UvurAAAAAElFTkSuQmCC);
					}

					span.better_invalid_field {
						background: 0 0 no-repeat url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAJPSURBVDjLpZPLS5RhFMYfv9QJlelTQZwRb2OKlKuINuHGLlBEBEOLxAu46oL0F0QQFdWizUCrWnjBaDHgThCMoiKkhUONTqmjmDp2GZ0UnWbmfc/ztrC+GbM2dXbv4ZzfeQ7vefKMMfifyP89IbevNNCYdkN2kawkCZKfSPZTOGTf6Y/m1uflKlC3LvsNTWArr9BT2LAf+W73dn5jHclIBFZyfYWU3or7T4K7AJmbl/yG7EtX1BQXNTVCYgtgbAEAYHlqYHlrsTEVQWr63RZFuqsfDAcdQPrGRR/JF5nKGm9xUxMyr0YBAEXXHgIANq/3ADQobD2J9fAkNiMTMSFb9z8ambMAQER3JC1XttkYGGZXoyZEGyTHRuBuPgBTUu7VSnUAgAUAWutOV2MjZGkehgYUA6O5A0AlkAyRnotiX3MLlFKduYCqAtuGXpyH0XQmOj+TIURt51OzURTYZdBKV2UBSsOIcRp/TVTT4ewK6idECAihtUKOArWcjq/B8tQ6UkUR31+OYXP4sTOdisivrkMyHodWejlXwcC38Fvs8dY5xaIId89VlJy7ACpCNCFCuOp8+BJ6A631gANQSg1mVmOxxGQYRW2nHMha4B5WA3chsv22T5/B13AIicWZmNZ6cMchTXUe81Okzz54pLi0uQWp+TmkZqMwxsBV74Or3od4OISPr0e3SHa3PX0f3HXKofNH/UIG9pZ5PeUth+CyS2EMkEqs4fPEOBJLsyske48/+xD8oxcAYPzs4QaS7RR2kbLTTOTQieczfzfTv8QPldGvTGoF6/8AAAAASUVORK5CYII%3D);
					}

				EOT
				return css
			end
	end
end

class ActionView::Base
	include BetterForm::ViewHelper
end
