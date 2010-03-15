Better Form Readme
==================

A Rails 2.3.x plugin to build DRY Wufoo style forms with AJAX validation.

* AJAX validates form fields as they are completed
* Well-placed validation output
* Automatic label generation
* Form field descriptions
* Sensible default form styling
* Unobtrusive Javascript contained in a single external file
* Options configurable at the application, form, and field level

Forget about labels, wrapper paragraphs, and cleaning up the `f.error_messages` output and enjoy *interactive* forms with far less code in your views.


Links
-----

* Online documentation: [http://rdoc.info/projects/nfm/better_form](http://rdoc.info/projects/nfm/better_form)
* Source code: [http://github.com/nfm/better_form](http://github.com/nfm/better_form)
* Bug/Feature tracking: http://github.com/nfm/better_form/issues


Installation
------------

1. **Prerequisite:** Install [jRails](http://github.com/aaronchi/jrails):

		script/plugin install git://github/com/aaronchi/jrails

2. Install the Better Form plugin from github:

		script/plugin install git://github.com/nfm/better_form.git

3. Include `better_form.css` and `better_form.js` (after jQuery and jRails) in `app/views/layouts/default.html.erb`:

		<%= stylesheet_link_tag 'better_form' %>
		<%= javascript_include_tag 'jquery', 'jrails', 'better_form' %>

4. Restart WEBrick and you're ready for better forms!


Usage
-----

1. Handle AJAX validation in your controllers by calling `ajax_validates_for`:

		ajax_validates_for :model

		class UsersController < ApplicationController
		  ajax_validates_for :user
		  ...
		end

2. Ensure the default `:controller/:action/:id` routes exist at the bottom of `config/routes` for your AJAX validation methods:

		map.connect ':controller/:action/:id'
		map.connect ':controller/:action/:id.:format'

3. Generate a better form by calling `better_form_for`:

		<% better_form_for @user do |f| %>
		  ...
		<% end %>

4. Generate fields with labels, descriptions, validation and 'required field' indicators using the regular form field methods:

		<%= f.text_field :first_name, :validated => true, :description => 'Display name used throughout site', :required => true %>

		<p class="better_field">
		  <input id="user_first_name" class="better_text_field better_validated_field" name="user[first_name]" type="text" size="30" />
		  <span class="better_required_field">*</span>
		  <br />
		  <span class="better_described_field">Display name used throughout site</span>
		</p>

		<%= f.text_field :last_name %>

		<p class="better_field">
		  <input id="user_last_name" class="better_text_field" value="Last name" name="user[last_name]" type="text" size="30" />
		</p>

Sit back and watch as `:validated => true` fields are automatically AJAX validated using your validation rules defined in your models.

Marvel at the beautiful form fields generated from single lines of code.

Arguments and Configuration
---------------------------

Form fields can be `:validated`, `:labelled`, `:described` and `:required`. Fields without labels have their initial `value` set to the method they are associated with.

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

You can inspect the default styling in `vendor/plugins/better_form/lib/better_form/view_helper.rb`.
(The images used in `span.better_valid_field` and `span.better_invalid_field` are base64 encoded in their `background` declaration)

Credits
------

If you use this plugin in an app that's made you money, please [buy me a beer](http://pledgie.com/campaigns/9414)!

Copyright (c) 2010 Nicholas Firth-McCoy, released under the MIT license

This plugin borrows code and ideas from:

* Ryan Bates' [nested_form plugin](http://github.com/ryanb/nested_form) (and of course his excellent Railscasts)
* jbasdf's [validate_attributes plugin](http://github.com/jbasdf/validate_attributes)
