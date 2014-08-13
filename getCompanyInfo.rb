require 'rubygems'
require 'open-uri'
require 'json'

def organization_by_name(name)
#Looks for an Organization by name
	url = "http://api.crunchbase.com/v/2/organization/#{name}?user_key=411490520ad9db1b432e77f1a25735a8&order=updated_at%20desc"
	JSON.parse(open(url).read)
end

puts 'Write the Company\'s Name: '
STDOUT.flush
nombre = gets.chomp

result = organization_by_name(nombre)
puts "\n"
puts 'Name: ' + result["data"]["properties"]["name"]
puts 'Email: ' + result["data"]["properties"]["email_address"]
puts 'Homepage: ' + result["data"]["properties"]["homepage_url"]
puts 'Founded on: ' + result["data"]["properties"]["founded_on"]
puts "\n"
puts "Current Team: "
result["data"]["relationships"]["current_team"]["items"].each do |x|
	puts "\t#{x['title']}: #{x['first_name']} #{x['last_name']}"
end				
puts "Pags: "
result["data"]["relationships"]["websites"]["items"].each do |y|
	puts "\t#{y['url']}"
end
puts "Headquarters: "
result["data"]["relationships"]["headquarters"]["items"].each do |z|
	puts "\t#{z['street_1']}"
	puts "\t#{z['city']}"','"#{z['region']}"','"#{z['country_code']}"				
end
puts "\n"