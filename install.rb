# Install better_form.js to public/javascripts/
path = "public/javascripts/better_form.js"
puts "Generating #{path}"
File.open("#{Rails.root}/#{path}", "w") do |file|
  file.print <<-EOS
$(function() {
  var initialValue = '';

  $('input.better_text_field').focus(function() {
		// If this field is not already valid, store the initial value and clear the input
		if (!$(this).hasClass('better_valid_field')) {
			initialValue = this.value;
			this.value = '';
		}
  });

  $('input.better_text_field').blur(function() {
    // Restore the initial value if the field is required and no value was entered
    if ($(this).hasClass('better_required_field') && (this.value == '')) {
      this.value = initialValue;
    // Else mark the field as completed
    } else {
      $(this).addClass('better_completed_field');
    }
  });

  $('input.better_validated_field').blur(function() {
    $.ajax({data:'authenticity_token=' + encodeURIComponent('iH4oAzNSO8OUiyFjVksfIdjEzmiWbL5BfM3mgp4rws4=')+ '&' + this.name + '=' + this.value + '&field_id=' + this.id, dataType:'script', type:'post', url: 'ajax_validate_' + this.id});
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
EOS
end
