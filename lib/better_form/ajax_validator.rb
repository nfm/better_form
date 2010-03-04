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
							# If the model is valid on the given attribute
							if model.to_s.camelize.constantize.better_valid_on?(params[model])
								# Mark the field as valid
								page << "markFieldValid('#{params[:field_id]}')"
							else
								# Mark the field as invalid
								page << "markFieldInvalid('#{params[:field_id]}')"
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
