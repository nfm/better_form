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

Include `public/javascripts/better_form.js` after jQuery:

		<%= javascript_include_tag 'jquery', 'better_form' %>

You can then generate a better form using the `better_form_for` method:

		<% better_form_for @project do |f| %>

Form fields have a `<br />` appended after them. They can be `:validated`, `:labelled`, and `:required`.

* A validated field has the class 'better_validated_field' added to its list of class names:

		<%= f.text_field :first_name, :validated => true %>
		<input class="better_text_field  better_validated_field" id="person_first_name" name="person[first_name]" size="30" title="First name" type="text" value="First name" /><br />

* A required field has the class 'better_required_field' added to its list of class names, and an '*' appended to it:

		<%= f.text_field :first_name, :required => true %>
		<input class="better_text_field  better_required_field" id="person_first_name" name="person[first_name]" size="30" title="First name" type="text" value="First name" /><span class="better_required_field">&nbsp;*</span><br />

I A labelled field has a label prepended to it:

		<%= f.text_field :first_name, :labelled => true %>
		<label class="better_label" for="person_first_name">First name</label><br />
		...

The javascript file better_form.js watches validated fields and calls their (generated) controller method to validate them when they are changed. This method returns an inline notification of the validity of the field.

Credits
------

This plugin borrows code and ideas from:

* Ryan Bates' [nested_form plugin](http://github.com/ryanb/nested_form) (and of course his excellent Railscasts)
* jbasdf's [validate_attributes plugin](http://github.com/jbasdf/validate_attributes)


Copyright (c) 2010 Nicholas Firth-McCoy, released under the MIT license
