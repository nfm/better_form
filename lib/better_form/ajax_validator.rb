module BetterForm
	module AjaxValidator
		def self.included(base)
			base.class_eval do
				extend ClassMethods
			end
		end

		module ClassMethods
			def ajax_validates_for(model, options = {})
				# Unless options[:include_default_attributes] was explicitly assigned => false
				unless options.delete(:include_default_attributes) == false
					object = model.to_s.camelize.constantize.new
					ajax_attributes = object.attributes.symbolize_keys.keys
				else
					ajax_attributes = []
				end

				# If :include => [attributes] was passed as an argument
				if included_attributes = options.delete(:include)
					# Add each included attribute to the array of ajax attributes
					ajax_attributes.concat(included_attributes).uniq!
				end

				# If :exclude => [attributes] was passed as an argument
				if excluded_attributes = options.delete(:exclude)
					# Remove each excluded attribute from the array of ajax attributes
					ajax_attributes -= excluded_attributes
				end

				# For each attribute to ajax validate
				ajax_attributes.each do |attribute|
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
