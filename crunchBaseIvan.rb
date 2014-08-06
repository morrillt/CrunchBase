require 'open-uri'
require 'json'

# returns a page with organizations informationt
# ex: 
def get_organization_page(page)
	base_url = "http://api.crunchbase.com/v/2/organizations"
	user_key = "2f9f86ebf459116f9b1a6e86f24ba34b"
	url = "#{base_url}?page=#{page}&user_key=#{user_key}"
	JSON.parse(open(url).read)
end

# returns all the names of the organizations in crunchbase
def get_all_organization_names
	organizations = Array.new
	page = 1
	begin
		result = get_organization_page(page)
		result['data']['items'].each do |organization|
			organizations << organization['name']
			puts organization["name"] #only for debug
		end
		sleep(2)
		next_url = result['data']['paging']['next_page_url']
		page = page + 1
	end while next_url != nil
	organizations
end

x = "mehhh"
x = get_all_organization_names
