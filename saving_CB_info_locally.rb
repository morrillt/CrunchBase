
require 'open-uri'
require 'json'

class Crunch_base

	# Instances variables
	def initialize
		@names = Array.new
		@paths = Array.new
		@domains = Array.new
		@permalink = Array.new
		@CEOandCTO = Array.new
		@random_key = 1
	end


	# Get specific information(info) of an url(page)
	# info can be "updated_at" | "name" | "path" | "created_at" | "type"
	def get_information_all_companies()
		page = 275
		begin
			url = create_url("organizations","",page)
			puts "Reading #{url}"
			result = read_url(url)
			#save_json(result, ["organizations"])

			add_organization_info(result,"name")
			add_organization_info(result,"path")
			
			next_url = result['data']['paging']['next_page_url']
			page = page + 1
		end while next_url != nil
		create_permalink(@paths)
		save_json("", ["names", "paths", "permalinks"])
	end

	def get_information_one_company()
			count = 1
			file = File.read("/Users/Isabel/Documents/Ruby/CrunchBase/permalinks.js")
			permalink = JSON.parse(file)
			permalink.each do |link|
				url = create_url("organization",link,1)
				puts "#{count} of #{@permalink.size}  Reading #{url}"
				result = read_url(url)
				save_json(result, ["organization"])
				if result['data']['relationships']['current_team'] != nil
					result['data']['relationships']['current_team']['items'].each do |person|
						if isCEOorCTO(person['title'])
							@CEOandCTO << person['first_name']
							@CEOandCTO << person['last_name']
							@CEOandCTO << create_domain(result['data']['properties']['homepage_url'])
							@CEOandCTO << person['title']
							@CEOandCTO << result['data']['properties']['name']
						end
					end
				else 
					#puts "There isn't CEO neither CTO in #{link}"
				end
				save_json("", ["CEOandCTO", "permalinks"])
				count = count + 1
			end 	
	end

	def save_json(content, types)
		types.each do |type|
			if type == "organizations"
				file = File.open("/Users/Isabel/Documents/Ruby/CrunchBase/result_organizations.js", "a")
				file.write("#{content} \n")
			elsif type == "organization"
				file = File.open("/Users/Isabel/Documents/Ruby/CrunchBase/result_organization.js", "a")	
				file.write("#{content} \n")
			elsif type == "CEOandCTO"
				file = File.open("/Users/Isabel/Documents/Ruby/CrunchBase/CEOandCTO.js", "a")
				file.write("#{@CEOandCTO} \n")
			elsif type == "names"
				file = File.open("/Users/Isabel/Documents/Ruby/CrunchBase/names.js", "a")
				file.write("#{@names} \n")
			elsif type == "paths"
				file = File.open("/Users/Isabel/Documents/Ruby/CrunchBase/paths.js", "a")
				file.write("#{@paths} \n")
			elsif type == "domains"
				file = File.open("/Users/Isabel/Documents/Ruby/CrunchBase/domains.js", "a")
				file.write("#{@domains} \n")
			elsif type == "permalinks"
				file = File.open("/Users/Isabel/Documents/Ruby/CrunchBase/permalinks.js", "a")
				file.write("#{@permalinks} \n")
			end
	 		file.close
	 	end
	end 
	def isCEOorCTO(title)
		if title.downcase.include? "ceo" then
			true
		elsif title.downcase.include? "cto" then
			true
		elsif title.downcase.include? "president" then
			true
		elsif title.downcase.include? "chief executive officer" then
			true
		elsif title.downcase.include? "chief technology officer" then
			true
		else 
			false
		end		
	end


	# Type can be organizations | organization | people | person | products | product | fundingRound | acquisition | fundraise
	# Permalink is an substring of the organization's path.  - Use create_permalink to get an array with all paths.
	# page is the number of the page that you want to consult.
	def create_url (type,permalink,page)
		base_url = "http://api.crunchbase.com/v/2/"
		user_key = "2f9f86ebf459116f9b1a6e86f24ba34b" # This's Isabel's key
		user_key2 = "411490520ad9db1b432e77f1a25735a8" # This's David's Key
		if permalink == "" then
			if @random_key == 1
				url = "#{base_url}#{type}?page=#{page}&user_key=#{user_key}"
				@random_key = 2
			elsif @random_key == 2
				url = "#{base_url}#{type}?page=#{page}&user_key=#{user_key2}"
				@random_key = 1
			end
		else
			if @random_key == 1
				url = "#{base_url}#{type}/#{permalink}?page=#{page}&user_key=#{user_key}"
				@random_key = 2
			elsif @random_key == 2
				url = "#{base_url}#{type}/#{permalink}?page=#{page}&user_key=#{user_key2}"
				@random_key = 1
			end
		end 
		return url 
	end

	def read_url(url)
		sleep(1)
		JSON.parse(open(url).read)
	end 

	# Extract permalinks of an array of paths
	# Ex: if path=>"organization/futurebooks" then permalink =>futurebooks
	def  create_permalink(paths)
		#puts "Path is really empty? \n #{paths}"
		if paths != []
			paths.each do |path|
				if path.include? "\/" then
					@permalink << path.split("\/").last
				end
			end
			puts "This shouldn't be empty #{@permalinks}"
		end
	end 

	def create_domain(homepage)
		if homepage != nil
			if homepage.downcase.include? "www" then
				homepage.split("www.").last
			else 
				homepage.split("\/\/").last
			end
		end 
	end

	# Add information to the instances variables.
	# info can be "updated_at" | "name" | "path" | "created_at" | "type"
	def add_organization_info(result, info)
		result['data']['items'].each do |organization|
			if info == "name"
				@names << organization[info]
			elsif info == "path"
				@paths << organization[info]
			end
		end
	end

end 

	a = Crunch_base.new
	a.get_information_all_companies

