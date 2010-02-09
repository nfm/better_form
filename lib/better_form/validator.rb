module BetterForm
	module Validator
		def self.included(base)
			base.class_eval do
				extend ClassMethods
			end
		end

		module ClassMethods
			def better_valid_on?(params)
				# What class is this?
				class_name = self.class_name.parameterize.to_s
				# Pull the necessary fields out of params
				object = self.new(params[class_name])
				return object.valid?
			end
		end
	end
end

class ActiveRecord::Base
	include BetterForm::Validator
end
