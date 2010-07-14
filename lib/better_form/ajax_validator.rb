module BetterForm
	module AjaxValidator
		def self.included(base)
			base.class_eval do
				extend ClassMethods
			end
		end

		module ClassMethods
			def ajax_validates_for(model, options = {})
				klass = model.to_s.camelize.constantize
				object = klass.new

				# Unless options[:include_default_attributes] was explicitly assigned => false
				unless options.delete(:include_default_attributes) == false
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
					define_ajax_validate_attribute_method(klass, model, attribute)
				end

				# For each model that this model accepts_nested_attributes_for
				nested_attributes_models = []
				nested_attributes_models = object.nested_attributes_options.keys
				nested_attributes_models.each do |nested_model|
					# Initialize an object of this nested_model
					klass = nested_model.to_s.singularize.camelize.constantize
					object = klass.new

					# Extract the object's attributes
					ajax_attributes = []
					ajax_attributes = object.attributes.symbolize_keys.keys

					# Define an ajax validation method for each of the object's attributes
					ajax_attributes.each do |attribute|
						# Concatenate model and nested_model so that the method name we define matches
						# the dom id generated for the field and used for the URL to validate at
						define_ajax_validate_attribute_method(klass, "#{model}_#{nested_model}", attribute)
					end
				end

				# Define another method ajax_validate_new_X to handle ajax form submission
				define_method("ajax_validate") do
					object = klass.new(params[model])
					render :update do |page|
						# If the all validations are passed
						if object.valid?
							page << "validForm = true;"
						else
							errors = object.errors.instance_variable_get('@errors')
							page << "validForm = false;"
							# Mark each invalid field as invalid
							errors.each do |attr, error|
								page << "markFieldInvalid('#{model}_#{error[0].instance_variable_get('@attribute')}', '#{escape_javascript(error[0].to_s)}');"
							end
						end
					end
				end
			end

		private
			def define_ajax_validate_attribute_method(klass, model, attribute)
				# Define a method 'ajax_validates_for_X'
				define_method("ajax_validate_#{model}_#{attribute}") do
					render :update do |page|
						# If the model is valid on the given attribute
						if (errors = klass.better_valid_on?(params[model])).blank?
							# Mark the field as valid
							page << "markFieldValid('#{params[:field_id]}');"
						else
							# Mark the field as invalid
							page << "markFieldInvalid('#{params[:field_id]}', '#{escape_javascript(errors[0].to_s)}');"
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
