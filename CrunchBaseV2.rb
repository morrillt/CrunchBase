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
	end

	# Get specific information(info) of an url(page)
	# info can be "updated_at" | "name" | "path" | "created_at" | "type"
	def get_organizations_all_pages(info)
		page=1
		begin
			url = create_url("organizations","",page)
			result = read_url(url)
			next_url = result['data']['paging']['next_page_url']

			add_organization_info(result,"name")
			add_organization_info(result,"path")

			page = page + 1
		end while page <= 1 #next_url != nil
		get_CEOandCTO_names
		puts "Domains of companies with CEO or CTO known  #{@domains}"
		puts "Organization = #{@names} \n Information about CEO's and CTO's = #{@CEOandCTO} \n Number of domains known = #{@domains}"
	end

	# Type can be organizations | organization | people | person | products | product | fundingRound | acquisition | fundraise
	# Permalink is an substring of the organization's path.  - Use create_permalink to get an array with all paths.
	# page is the number of the page that you want to consult.
	def create_url (type,permalink,page)
		base_url = "http://api.crunchbase.com/v/2/"
		user_key = "2f9f86ebf459116f9b1a6e86f24ba34b" # This's Isabel's key
		user_key2 = "411490520ad9db1b432e77f1a25735a8" # This's David's Key
		if permalink == "" then
			url = "#{base_url}#{type}?page=#{page}&user_key=#{user_key2}"
		else
			url = "#{base_url}#{type}/#{permalink}?page=#{page}&user_key=#{user_key}"
		end
	end

	def read_url(url)
		sleep(2)
		JSON.parse(open(url).read)
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

	def get_CEOandCTO_names()
		path = @paths
		permalink = create_permalink(path) 
		puts permalink.size
		permalink.each do |link|
			url = create_url("organization",link,1)
			result = read_url(url)
			if result['data']['relationships']['current_team'] != nil
				puts "There's current team for #{link}"
				result['data']['relationships']['current_team']['items'].each do |person|
					if isCEOorCTO(person['title'])
						@CEOandCTO << result['data']['properties']['name']
						@CEOandCTO << person['first_name']
						@CEOandCTO << person['last_name']
						@CEOandCTO << person['title']
						create_domain(result['data']['properties']['homepage_url'])
						puts "#{link} just added :)"
					end
				end
			else 
				puts "There isn't CEO neither CTO in #{link}"
			end
		end 
	end

	# Extract permalinks of an array of paths
	# Ex: if path=>"organization/futurebooks" then permalink =>futurebooks
	def  create_permalink(paths)
		paths.each do |path|
			@permalink << path.split("\/").last
		end
		@permalink
	end 

	def create_domain(homepage)
		if homepage != nil
			if homepage.downcase.include? "www" then
				@domains <<  "@#{homepage.split("www.").last}" 
			else 
				@domains << "@#{homepage.split("\/\/").last}" 
			end
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


end 

	a = Crunch_base.new
 	a.get_organizations_all_pages('name')
 	#a.create_domain("http://bitglass.com")
