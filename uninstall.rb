# Remove better_form files generated by install.rb
remove_file "public/javascripts/better_form.js"
remove_file "public/stylesheets/better_form.css"
remove_file "config/initializers/better_form.rb"

def remove_file(file)
	puts "Removing #{file}"
	begin
		File.delete(file)
	rescue Exception => e
		puts "Unable to remove #{file}"
		puts e
	end
end
