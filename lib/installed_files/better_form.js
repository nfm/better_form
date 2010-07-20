$(function() {
  $('input.better_text_field').focus(function() {
    // If this field contains the default value, clear the field
		if (this.value == this.defaultValue) {
      this.value = '';
    }
  });

  $(':text.better_text_field, textarea.better_text_field').blur(function() {
    // If a required field is blank, restore its default value
    if ($(this).hasClass('better_required_field') && (this.value == '')) {
      this.value = this.defaultValue;
      removeValidationOutput(this.id);
    // Else mark the field as completed
    } else {
      $(this).addClass('better_completed_field');
    }
  });

  $(':checkbox.better_validated_field').focus(validateField);
  $(':radio.better_validated_field').focus(validateField);
  $(':file.better_validated_field').change(validateField);
  $('select.better_validated_field').change(validateField);
  $(':password.better_validated_field').blur(validateField);
  $(':text.better_validated_field').blur(validateField);
  $('textarea.better_validated_field').blur(validateField);

  $(':input.better_text_field').focus(function() {
    $(this).parent('p').addClass('better_focused_field');
  });

  $(':input.better_text_field').blur(function() {
    $(this).parent('p').removeClass('better_focused_field');
  });

	$('form.better_form').submit(checkFormIsCompleted);
});

function validateField() {
  // If the field is a text_field and its value has not been changed from the default value
  if ($(this).is(':text, textarea, :password') && (this.value == this.defaultValue)) {
    return;
  }

	// If this field is a radio button, use the associated label's `for` attribute as the method to call
	// This ensures that a group of radio buttons call the _same_ method, rather than each having a unique validation method
	// ie don't call user_plan_free or user_plan_corporate, call user_plan with the argument free or corporate
	if ($(this).is(':radio')) {
		method = $(this).prevAll("label.better_label").attr('for');
	} else {
		method = this.id;
	}

	var ajax_url = $(this).attr('data-ajax-validation-url');
	var field_model_name = $(this).attr('data-model-name');
	var field_attribute_name = $(this).attr('data-attribute-name');

  $.ajax({data:'authenticity_token=' + getAuthenticityToken() + '&model=' + field_model_name + '&attribute=' + field_attribute_name + '&' + field_model_name + '[' + field_attribute_name + ']' + '=' + this.value + '&field_id=' + this.id, dataType:'script', type:'post', url: ajax_url, async: false});
}

function checkFormIsCompleted(e) {
	var ajax_url = $(this).closest('form').attr('action');
	ajax_url = ajax_url.replace(/^(\/[^\/]+)(.*)$/, "$1");
	ajax_url = ajax_url + '/ajax_validate';

	var formData = $(this).serialize();
	// Explicitly replace the value of the hidden field '_method' if it has been initialized with 'put'
	// ie. we are editing an existing record
	// This makes sure that the controller doesn't try to call the 'update' method with id='ajax_validate'
	formData = formData.replace(/_method=put/, "_method=post")

  $.ajax({data: formData + '&field_id=' + this.id, dataType:'script', type:'post', url: ajax_url, async: false});
	if (validForm == true) {
		return true;
	} else {
		return false;
	}
}

function removeValidationOutput(id) {
  field = "#" + id;
  $(field).removeClass('better_invalid_field');
  $(field).removeClass('better_valid_field');
  $(field).removeClass('better_completed_field');
  $(field).parent().children('span.better_invalid_field').remove();
  $(field).parent().children('span.better_valid_field').remove();
  $(field).parent().children('span.better_error_message').remove();
}

function markFieldValid(id) {
  // Remove existing invalid/valid notifications
  removeValidationOutput(id);

  field = "#" + id;

	// If the valid field is a radio button, add the validation output next to the group of radio buttons' label
	if ($(field).is(':radio')) {
		label = $(field).siblings('label.better_label').nextAll('br').first().before('<span class="better_valid_field"></span>');
	// For all other field types, add the validation output just after the field
	} else {
		$(field + ' ~ br').before('<span class="better_valid_field"></span>');
	}
  $(field).addClass('better_valid_field');
}

function markFieldInvalid(id, errorMessage) {
  // Remove existing invalid/valid notifications
  removeValidationOutput(id);

  field = "#" + id;
  $(field + ' ~ br').before('<span class="better_invalid_field"></span>');
  $(field).addClass('better_invalid_field');
  $(field).parent('p').append('<span class="better_error_message">' + errorMessage + '</span>');
}

function getAuthenticityToken() {
	var authenticityToken = "";
	authenticityToken = encodeURIComponent($("[name='authenticity_token']").attr('value'));
	return authenticityToken;
}
