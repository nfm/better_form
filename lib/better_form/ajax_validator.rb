module BetterForm
	module AjaxValidator
		def self.included(base)
			base.class_eval do
				extend ClassMethods
			end
		end

		module ClassMethods
			def ajax_validates_for(model, *attributes)
				# For each attribute to validate
				attributes.each do |attribute|
					# Define a method 'ajax_validates_for_X'
					define_method("ajax_validate_#{model}_#{attribute}") do
						render :update do |page|
							# Remove existing invalid/valid notifications
							page.select("##{params[:field_id]} + .better_invalid_field").remove()
							page.select("##{params[:field_id]} + .better_valid_field").remove()
							# If the model is valid on the given attribute
							if model.to_s.camelize.constantize.better_valid_on?(params)
								page.insert_html :after, params[:field_id], '<span class="better_valid_field"></span>'
							else
								page.insert_html :after, params[:field_id], '<span class="better_invalid_field"></span>'
							end
						end
					end
				end
			end
		end
	end
end

class ActionController::Base
	include BetterForm::AjaxValidator
end
