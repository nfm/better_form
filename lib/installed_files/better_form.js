$(function() {
  $('input.better_text_field, textarea.better_text_field').focus(function() {
    // If this field contains the default value, clear the field
		if (this.value == $(this).attr('data-default-value')) {
      this.value = '';
    }
  });

	// Mark pre-populated fields as completed by giving them the class 'better_completed_field'
	$('input.better_text_field, textarea.better_text_field').each(function() {
		if (this.value != $(this).attr('data-default-value')) {
			$(this).addClass('better_completed_field');
		}
	});

  $('input.better_text_field, textarea.better_text_field').blur(function() {
    // If a required field is blank, restore its default value
    if ($(this).hasClass('better_required_field') && (this.value == '')) {
      this.value = this.defaultValue;
      removeValidationOutput(this.id);
    // Else mark the field as completed
    } else {
      $(this).addClass('better_completed_field');
    }
  });

	/* Validate checkboxes and radio buttons when they are focused on */
	$('.better_validated_field').filter(':checkbox,:radio').focus(function() { validateField(this) });
	/* Validated file fields and selects when their value is changed */
	$('.better_validated_field').filter(':file,select').change(function() { validateField(this) });
	/* Validate password and text fields and textareas when they lose focus */
	$('.better_validated_field').filter(':password,:text,textarea').blur(function() { validateField(this) });

  $(':input.better_text_field').focus(function() {
    $(this).parent('p').addClass('better_focused_field');
  });

  $(':input.better_text_field').blur(function() {
    $(this).parent('p').removeClass('better_focused_field');
  });

	$('form.better_form').submit(checkFormIsCompleted);
});

function validateField(field) {
  // If the field is a text_field and its value has not been changed from the default value
  if ($(field).is(':text, textarea, :password') && (field.value == $(field).attr('data-default-value'))) {
    return;
  }

	// If this field is a radio button, use the associated label's `for` attribute as the method to call
	// This ensures that a group of radio buttons call the _same_ method, rather than each having a unique validation method
	// ie don't call user_plan_free or user_plan_corporate, call user_plan with the argument free or corporate
	if ($(field).is(':radio')) {
		method = $(field).prevAll("label.better_label").attr('for');
	} else {
		method = field.id;
	}

	var ajax_url = $(field).attr('data-ajax-validation-url');
	var field_model_name = $(field).attr('data-model-name');
	var field_attribute_name = $(field).attr('data-attribute-name');

  $.ajax({
		data: 'authenticity_token=' + getAuthenticityToken() + '&model=' + field_model_name + '&attribute=' + field_attribute_name + '&' + field_model_name + '[' + field_attribute_name + ']' + '=' + field.value + '&field_id=' + field.id,
		dataType: 'script',
		type: 'post',
		url: ajax_url,
		async: true
	});
}

function checkFormIsCompleted() {
	// Find all fields that have been marked for validation
	var fieldsToValidate = $(this).find(':input.better_validated_field').not('.better_valid_field');

	// If no fields are to be validated, return true
	if (fieldsToValidate.size() == 0) {
		return true;
	}

	var data = 'authenticity_token=' + getAuthenticityToken() + '&model=' + $(this).attr('data-model-name');
	fieldsToValidate.each(function() {
		data += '&' + $(this).serialize();
	});

  $.ajax({
		data: data,
		dataType: 'script',
		type: 'post',
		url: '/better_ajax_validation/ajax_validate_model',
		async: false
	});

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
