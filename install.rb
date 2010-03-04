# Install better_form.js to public/javascripts/
path = "public/javascripts/better_form.js"
puts "Generating #{path}"
File.open("#{Rails.root}/#{path}", "w") do |file|
  file.print <<-EOS
$(function() {
  $('input.better_text_field, textarea.better_text_field').focus(function() {
    // If this field contains the default value, clear the field
		if (this.value == this.defaultValue) {
      this.value = '';
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

  $('input.better_validated_field').blur(function() {
    // If the field's value has been changed from the default value, validate it
    if (this.value != this.defaultValue) {
      $.ajax({data:'authenticity_token=' + encodeURIComponent('iH4oAzNSO8OUiyFjVksfIdjEzmiWbL5BfM3mgp4rws4=')+ '&' + this.name + '=' + this.value + '&field_id=' + this.id, dataType:'script', type:'post', url: 'ajax_validate_' + this.id, async: false});
      checkFormIsCompleted(this.form);
    }
  });

});

function shake(id) {
  var id = '#' + id;
  $(id).css({'position': 'relative'});
  $(id).animate({'left': '-=3px'}, 30);
  $(id).animate({'left': '+=6px'}, 60);
  $(id).animate({'left': '-=6px'}, 60);
  $(id).animate({'left': '+=6px'}, 60);
  $(id).animate({'left': '-=6px'}, 60);
  $(id).animate({'left': '+=6px'}, 60);
  $(id).animate({'left': '0px'}, 30);
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
  shake(id);
}
EOS
end
