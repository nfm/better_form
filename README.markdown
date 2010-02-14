Better Form
===========

A Rails plugin to build nicer forms. Better Form currently handles:

* AJAX validation of form fields as they are completed
* Enabling/disabling the form's submit button if the form is valid/invalid
* Automatic label generation

Better Form requires jQuery 1.4 and jRails.


Install
-------

	script/plugin install git://github.com/nfm/better_form.git

(Don't forget to restart WEBrick if necessary)

Usage
-----

Include `public/javascripts/better_form.js` after jQuery and jRails:

	<%= javascript_include_tag 'jquery', 'jrails', 'better_form' %>

Add methods to your controllers to handle AJAX validation:

	ajax_validates_for :model, :attribute, [:attribute] ...

	class UsersController < ApplicationController
	  ajax_validates_for :user, :first_name, :last_name
	  ...
	end

Add named routes in `config/routes` for your AJAX validation methods, or keep the default `:controller/:action/:id` routes:

	map.resources :user, :collection => { :ajax_validate_user_first_name => :post, :ajax_validate_user_last_name => :post, ... }

	# Or just keep these at the end of the file:
	map.connect ':controller/:action/:id'
	map.connect ':controller/:action/:id.:format'


You can then generate a better form using the `better_form_for` method:

	<% better_form_for @project do |f| %>

Form fields have a `<br />` appended after them. They can be `:validated`, `:labelled` and `:required`. Fields without labels have their initial `value` set to the method they are associated with.

* A validated field has the class `better_validated_field` added to its list of class names:

		<%= f.text_field :first_name, :validated => true %>
		<input class="better_text_field  better_validated_field" id="person_first_name" name="person[first_name]" size="30" title="First name" type="text" value="First name" /><br />

* A required field has the class `better_required_field` added to its list of class names, and an `*` appended to it:

		<%= f.text_field :first_name, :required => true %>
		<input class="better_text_field  better_required_field" id="person_first_name" name="person[first_name]" size="30" title="First name" type="text" value="First name" /><span class="better_required_field">*</span><br />

* A labelled field has a label prepended to it:

		<%= f.text_field :first_name, :labelled => true %>
		<label class="better_label" for="person_first_name">First name</label><br />
		...

Alternatively, you can pass `:validate_all`, `:label_all` and `:require_all` as options to `better_form_for` to apply the given options to every field.

The javascript file `better_form.js` watches validated fields and calls their (generated) controller method to validate them when they are changed. This method returns an inline notification of the validity of the field.

If you like, you can restyle the default CSS by overriding the following selectors in your own stylesheet:

	input.better_text_field
	input.better_text_field:focus
	input.better_completed
	span.better_required_field
	span.better_valid_field
	span.better_invalid_field
	input.better_valid_field
	input.better_invalid_field
	label.better_label
	span.better_described_field

You can inspect the default styling in `vendor/plugins/better_form/lib/better_form/view_helper.rb`.
(The images used in `span.better_valid_field` and `span.better_invalid_field` are base64 encoded in their `background` declaration)

Credits
------

This plugin borrows code and ideas from:

* Ryan Bates' [nested_form plugin](http://github.com/ryanb/nested_form) (and of course his excellent Railscasts)
* jbasdf's [validate_attributes plugin](http://github.com/jbasdf/validate_attributes)


Copyright (c) 2010 Nicholas Firth-McCoy, released under the MIT license
