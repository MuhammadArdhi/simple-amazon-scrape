require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'colored'
require 'mechanize'

query = 'ruby'
page_number = '2'
url = "http://www.amazon.com/s/field-keywords=#{query}?page=#{page_number}"

# you could choose free proxy server, at this time I used proxy in gimmeproxy.com
proxy_ip = 'xxx.xxx.xxx.xxx'
proxy_port = 'xxxx'

agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" } # create a new Mechanize object and identify ourself as a common user agent
agent.set_proxy proxy_port, proxy_port # setup standard proxy without authentication
page = agent.get(url).body # fetches the html source of the page

doc = Nokogiri::HTML(open(page))

doc.css('#resultsCol').css('.s-result-item').map do |el|
	# grab the title
	title = el.css('.s-access-title').text.strip	
	# grab the image
	image = el.css('.s-access-image')[0]['src']
	# grab the product link
	link = el.css('.s-access-detail-page')[0]['href']
	# grab the price of product
	price = el.css('.a-price').css('.a-offscreen')[0]
	price = price != nil ? price.text : '-'

	puts "#{title}".green
	puts "Image url:".yellow + " #{image}"
	puts "Amazon link:".yellow + " #{link}"
	puts "Price: #{price}".red
	puts ""
end
