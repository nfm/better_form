module BetterForm
	module Validator
		def self.included(base)
			base.class_eval do
				extend ClassMethods
			end
		end

		module ClassMethods
			def better_valid_on?(attribute)
				# Create a new object using the given attribute
				object = self.new(attribute)
				# If the object is valid, return true
				if object.valid?
					return true
				else
					# Pull out the object's @errors hash
					errors = object.errors.instance_variable_get("@errors")
					# If there was an error for this attribute, return false
					if errors.include?(attribute.keys[0])
						false
					else
						true
					end
				end
			end
		end
	end
end

class ActiveRecord::Base
	include BetterForm::Validator
end
