require 'json'


class CEO_CTO_information 

	def initialize
		file = File.read("/Users/Isabel/Documents/Ruby/CrunchBase/asdf.rb")
		@CEO_CTO_info = JSON.parse(file)
	end 

	def get_CEO_CTO_information
		name = 0
		last_name = 1
		domain = 2
		num_people = @CEO_CTO_info.size/5
		for i in (1..num_people)  do
			#puts "name = #{@CEO_CTO_info[name]} \nLast Name = #{@CEO_CTO_info[last_name]} \nDomain = #{@CEO_CTO_info[domain]}"
			output = run_find_any_email(@CEO_CTO_info[name], @CEO_CTO_info[last_name], @CEO_CTO_info[domain])
			name = name + 5
			last_name = last_name + 5
			domain = domain	+ 5 
		end

	end

	def run_find_any_email(name, last_name, domain)
		puts "#{name} #{last_name} #{domain}"
		script_path = "/Users/Isabel/Documents/Ruby/find-any-email-master/find_email.rb"
		system ("ruby #{script_path} #{name} #{last_name} #{domain} >> CEOandCTOemails.js") 
	end

end

a = CEO_CTO_information.new
a.get_CEO_CTO_information