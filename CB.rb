require 'open-uri'
require 'json'

class Crunch_base
	
	def initialize
		@names = Array.new
		@path = Array.new
		@permalink = Array.new

	end



	# Get information of a specific url(page)
	# info can be "updated_at" | "name" | "path" | "created_at" | "type"
	def get_organizations_all_pages(info)
		page=1
		begin
			url = create_url("organizations","",page)
			result = read_url(url)
			sleep(2)
			next_url = result['data']['paging']['next_page_url']

			get_organization_info(result,info)
			page = page + 1
			puts "Page is #{page}"
		end while page <= 2 #next_url != nil
		puts @names.size
	end

	def get_organization_info(result, info)
		path = Array.new
		result['data']['items'].each do |organization|
			if info == "name"
				@names << organization[info]
			elsif info == "path"
				@path << organization[info]
			end
		end
	end

	def get_CEOandCTO_names()
		path = get_organizations_page(1,['path'])
		permalink = create_permalink(path) 
		permalink.each do |link|
			url = create_url("organization",link,1)
			puts result = read_url(url)


			#company = result[data]
			result['data']['relationships']['current_team']['items'].each do |person|
				puts "Entro!!!!!"
				if isCEOorCTO(person['title'])
					@organization << result["data"]['name']
					@organization << person['first_name', 'last_name', 'title']
				end 
				puts result["data"]['name']
				puts person['first_name', 'last_name', 'title']
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

	def create_url (type,permalink,page)
		base_url = "http://api.crunchbase.com/v/2/"
		user_key = "2f9f86ebf459116f9b1a6e86f24ba34b"
		if permalink == "" then
			url = "#{base_url}#{type}?page=#{page}&user_key=#{user_key}"
		else
			url = "#{base_url}#{type}/#{permalink}?page=#{page}&user_key=#{user_key}"
		end
	
	end

	def read_url(url)
		JSON.parse(open(url).read)
	end 


	# Extract permalinks of an array of paths
	# Ex: if path=>"organization/futurebooks" then permalink =>futurebooks
	def  create_permalink(paths)
		paths.each do |path|
			@permalink << path.split("\/").last
		end
		@permalink
	end

	def run_harvester_py(domain)
		path_py = "/Users/Isabel/Documents/Python/theHarvester-master/theHarvester.py"
		exec("python #{path_py} -d #{domain} -l 500 -b linkedin")
	end


end

	a = Crunch_base.new
 	a.get_organizations_all_pages('name')






