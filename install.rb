puts "Copying files..."

src_dir = File.join(File.dirname(__FILE__), "lib", "installed_files")
FileUtils.copy(File.join(src_dir, "better_form_initializer.rb"), "#{RAILS_ROOT}/config/initializers/better_form_initializer.rb")
FileUtils.copy(File.join(src_dir, "better_form.js"), "#{RAILS_ROOT}/public/javascripts/better_form.js")
FileUtils.copy(File.join(src_dir, "better_form.css"), "#{RAILS_ROOT}/public/stylesheets/better_form.css")

puts "Files copied - Installation complete!"
