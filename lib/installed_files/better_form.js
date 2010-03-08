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
  if ($(this).is(':text, textarea') && (this.value == this.defaultValue)) {
    return;
  }

  $.ajax({data:'authenticity_token=' + encodeURIComponent('iH4oAzNSO8OUiyFjVksfIdjEzmiWbL5BfM3mgp4rws4=')+ '&' + this.name + '=' + this.value + '&field_id=' + this.id, dataType:'script', type:'post', url: 'ajax_validate_' + this.id, async: false});
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
  $(field + " ~ .better_invalid_field").remove();
  $(field + " ~ .better_valid_field").remove();
}

function markFieldValid(id) {
  // Remove existing invalid/valid notifications
  removeValidationOutput(id);

  field = "#" + id;
  $(field + ' ~ br').before('<span class="better_valid_field"></span>');
  $(field).addClass('better_valid_field');
}

function markFieldInvalid(id) {
  // Remove existing invalid/valid notifications
  removeValidationOutput(id);

  field = "#" + id;
  $(field + ' ~ br').before('<span class="better_invalid_field"></span>');
  $(field).addClass('better_invalid_field');
}
