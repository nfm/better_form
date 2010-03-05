installed_files_dir = "#{Rails.root}/vendor/plugins/better_form/lib/installed_files"
install_file "better_form.js", :to => "public/javascripts/better_form.js"
install_file "better_form_initializer.rb", :to => "config/initializers/better_form.rb"
install_file "style.css", :to => "public/stylesheets/better_form.css"

def install_file(file, options = {})
	puts "Generating #{options[:to]}"
	File.copy("#{installed_files_dir}/#{file}", "#{Rails.root}/#{options[:to]}")
end
