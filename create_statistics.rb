require 'selenium-webdriver'
require 'yaml'
require_relative 'lib/create_company_script.rb'
require_relative 'lib/create_product.rb'
require_relative 'lib/create_pages.rb'

#configuration-reading
project = ENV['project'].nil? ? 'pc' :  ENV['project'] #pc/bz/yp
stand = ENV['stand'].nil? ? 1 : ENV['stand'].to_i #1/2/3/4/5
numbers_of_product = ENV['products'].nil? ? 1 : ENV['products'].to_i #1/2/..
pages = ENV['pages'].nil? ? true : ENV['pages'].to_b #true/false

CONFIG = YAML.load_file("config/#{project}.yml")
ST_CONFIG = YAML.load_file("config/#{project}#{stand}.yml")

#browser-initializing
@driver = Selenium::WebDriver.for(:chrome)
@driver.manage.window.maximize
@driver.navigate.to ST_CONFIG['auth_link']
@wait = Selenium::WebDriver::Wait.new(:timeout => 5)

rand = Random.new.rand(1000..9999)

#создаем компанию и получаем линк
comp = CompanyCreator.new @driver
comp_name = 'Default company name ' + rand.to_s
comp.create_company comp_name

#добавляем куку избавляющую от всплывающих окон
if project.eql? 'bz'
  company_id = @driver.find_element(:css, '.left-column .gray').text.split(' ')[1]
  @driver.manage.add_cookie(:name => 'hpHidden' + company_id, :value => '1')
  @driver.navigate.refresh
end

@driver.find_element(CONFIG['base']['link_to_mainpage']['type'], CONFIG['base']['link_to_mainpage']['locator']).click
company_link = @driver.current_url
if company_link[-1].eql? '/'
  company_link = company_link[0...-1]
end

#products
product_creator = ProductCreator.new(@driver, company_link, @wait)
products = []
product_name = 'Product '
for i in 1..numbers_of_product
  products << product_creator.create_product(product_name + i.to_s)
end

#other pages
links = []
if pages.eql? 'false'
  #do nothing
else
  page_creator = PageCreator.new(@driver, company_link)
  page_creator.create_newpage
  links << @driver.current_url
  page_creator.create_offer
  links << @driver.current_url
  page_creator.create_news
  links << @driver.current_url
  page_creator.create_article
  links << @driver.current_url
end

#разлогиниваемся
@driver.find_element(CONFIG['unlogin_link']['type'], CONFIG['unlogin_link']['locator']).click

#находим и заходим на КТ: парсим ссылки и заходим на ПКТ
portal_listing_list = []
products.each do |product|
  @driver.navigate.to(company_link + CONFIG['catalog'])
  @driver.find_element(:link, product).click
  @driver.navigate.to(ST_CONFIG['portal_link'] + CONFIG['catalog_p'] + product_creator.get_product_id(@driver.current_url))
end

links.each do |link|
  @driver.navigate.to(link)
end

text_no_automated_elements = '
*****************************************
* Не забудь посетить Портальный листинг *
* и страницу акции на портале вручную.  *
*****************************************'
text_statistic_hint = '
*********************************************
* Выполни на скриптовой машине              *
* bundle exec rake company_statistics:today *
*********************************************'

puts company_link + '/stats'
puts text_no_automated_elements
puts text_statistic_hint
