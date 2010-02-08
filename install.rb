# Install better_form.js to public/javascripts/
path = "public/javascripts/better_form.js"
puts "Generating #{path}"
File.open("#{Rails.root}/#{path}", "w") do |file|
  file.print <<-EOS
$(function() {
  var initialValue = '';

  $('input.better_text_field').focus(function() {
    /* If this field has not been completed */
    if (!$(this).hasClass('better_completed_field')) {
      initialValue = this.value;
      this.value = '';
    }
  });

  $('input.better_text_field').blur(function() {
    /* Reset the fields initial value if it wasn't filled it */
    if (this.value == '') {
      this.value = initialValue;
    } else {
      $(this).addClass('better_completed_field');
    }
  });
});
EOS
end
