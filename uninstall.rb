# Remove better_form.js from public/javascripts/
path = "public/javascripts/better_form.js"
puts "Removing #{path}"
begin
	File.remove(path)
rescue Exception => e
	puts "Unable to remove #{path}"
	puts e
end
