# Install better_form.js to public/javascripts/
path = "public/javascripts/better_form.js"
puts "Generating #{path}"
File.open("#{Rails.root}/#{path}", "w") do |file|
  file.print <<-EOS
$(function() {
  $('input.better_text_field, textarea.better_text_field').focus(function() {
		if (this.value == this.defaultValue) {
      this.value = '';
    }
    /*
		// If this field is marked for validation and is not already valid, clear the input
		if ($(this).hasClass('better_validated_field') && !$(this).hasClass('better_valid_field')) {
			this.value = '';
    // If this field is not marked for validation and contains the default value
		} else if (!$(this).hasClass('better_validated_field') && (this.value == this.defaultValue)) {
      this.value = '';
    }
    */
  });

  $('input.better_text_field, textarea.better_text_field').blur(function() {
    // Restore the initial value if the field is required and no value was entered
    if ($(this).hasClass('better_required_field') && (this.value == '')) {
      this.value = this.defaultValue;
    // Else mark the field as completed
    } else {
      $(this).addClass('better_completed_field');
    }
  });

  $('input.better_validated_field').blur(function() {
    $.ajax({data:'authenticity_token=' + encodeURIComponent('iH4oAzNSO8OUiyFjVksfIdjEzmiWbL5BfM3mgp4rws4=')+ '&' + this.name + '=' + this.value + '&field_id=' + this.id, dataType:'script', type:'post', url: 'ajax_validate_' + this.id, async: false});
    checkFormIsCompleted(this.form);
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
EOS
end
