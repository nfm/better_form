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
							page.select("##{params[:field_id]} ~ .better_invalid_field").remove()
							page.select("##{params[:field_id]} ~ .better_valid_field").remove()
							# If the model is valid on the given attribute
							if model.to_s.camelize.constantize.better_valid_on?(params[model])
								# Add an indicator that the input was valid
								page << "$('##{params[:field_id]} ~ .better_required_field').after('<span class=\"better_valid_field\"></span>');"
								page << "$('##{params[:field_id]}').removeClass('better_invalid_field');"
								page << "$('##{params[:field_id]}').addClass('better_valid_field');"
							else
								# Add an indicator that the input was invalid
								page << "$('##{params[:field_id]} ~ .better_required_field').after('<span class=\"better_invalid_field\"></span>');"
								page << "$('##{params[:field_id]}').removeClass('better_completed_field');"
								page << "$('##{params[:field_id]}').addClass('better_invalid_field');"
								page << "shake('#{params[:field_id]}');"
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
