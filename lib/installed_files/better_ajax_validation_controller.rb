class BetterAjaxValidationController < ApplicationController
	def ajax_validate_attribute
		model = params[:model]
		klass = model.to_s.camelize.constantize
		object = klass.new(params[model])

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

	def ajax_validate_model
		model = params[:model]
		klass = model.to_s.camelize.constantize
		object = model.new(params[model])

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
