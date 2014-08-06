require 'open-uri'
require 'json'

#
class Crunch_base
	
	def initialize
		@organizations = Array.new
	end

	def get_all_organization_names
		page=1
		begin
			next_url_exist = get_organizations_page(page, ["name", "path"])
			sleep(2)
			page = page + 1
		end while next_url_exist
	end

	def create_url (type, page)
		base_url = "http://api.crunchbase.com/v/2/"
		user_key = "2f9f86ebf459116f9b1a6e86f24ba34b"
		url = "#{base_url}#{type}?page=#{page}&user_key=#{user_key}"
	end

	def read_page(url)
		JSON.parse(open(url).read)
	end 

	
	def get_organizations_page(page, info)
		url = create_url("organizations", page)
		result = read_page(url)
		result['data']['items'].each do |organization|
			info.each do |i|	
				@organizations << organization[i]
				print organization[i] #only for debug
				print " "
			end
			print "\n"
			$stdout.flush
		end
		next_url = result['data']['paging']['next_page_url']
		next_url != nil
	end	

end

	a = Crunch_base.new
	a.get_all_organization_names



