$(function() {
  $('input.better_text_field, textarea.better_text_field').focus(function() {
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

  $.ajax({data:'authenticity_token=' + encodeURIComponent('iH4oAzNSO8OUiyFjVksfIdjEzmiWbL5BfM3mgp4rws4=')+ '&' + this.name + '=' + this.value + '&field_id=' + this.id, dataType:'script', type:'post', url: 'ajax_validate_' + method, async: false});
  checkFormIsCompleted(this.form);
}

function checkFormIsCompleted(form) {
  var validForm = false;
  var form = "#" + form.id;
  var validatedFields = $(form + ' input.better_validated_field');
  // For each validated field
  for (i = 0; i < validatedFields.length; i++) {
    // If any field is invalid, disable the form submit button
    if ($(validatedFields[i]).hasClass('better_invalid_field')) {
      $(form + ' :submit').disable();
      return;
		// If the field is valid, set validForm to true
    } else if ($(validatedFields[i]).hasClass('better_valid_field')) {
      validForm = true;
    }
  }
  if (validForm == true) {
    $(form + ' :submit').enable();
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
