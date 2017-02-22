# selenium_statistic_creator

# Requirements
gem selenium-webdriver
gem yml_reader
ruby v 2.2.0 or above

# Run
Variable in enviroment:

*project*: pc/bz/yp - dafault 'pc'

*stand*: 1/2/3/4/5 - dafault '1'

*numbers_of_product*: 1,2,etc. - numbers of created products in script, default '1'

*pages*: true/false - create or not pages: articles, new page, news; default 'true'

run 'ruby create_statistics.rb' to create minimal statistic on 1st staging pc

## Config
bz.yml pc.yml yp.yml
configs with locators and texts for projects
bz1.yml pc1.yml yp3.yml
configs with staging links

## Classes
PageCreator, file create_pages.rb, main methods:
* create_newpage
* create_offer
* create_news
* create_article

CompanyCreator, file create_company_script.rb, method:
* create_company(name='Default company name')

ProductCreator, file create_product.rb, methods:
* create_product(name=nil, rubr=nil) : name: product name; rubr: string with product rubric name
* search_rubric(rubric) : inner method for create_product method. Run this method only on product create page when rubric has not selected
* get_product_id(link) : method for executing product id from url link

## Example of usage in irb console
```ruby
require 'selenium-webdriver'
require_relative 'lib/create_company_script.rb'
require_relative 'lib/create_product.rb'
require_relative 'lib/create_pages.rb'
require 'yaml'
CONFIG = YAML.load_file("config/bz.yml")
ST_CONFIG = YAML.load_file("config/bz3.yml")
d = Selenium::WebDriver.for :chrome
d.manage.window.maximize
w = Selenium::WebDriver::Wait.new(:timeout => 5)

d.navigate.to ST_CONFIG['auth_link']
comp = CompanyCreator.new d

comp.create_company

d.find_element(CONFIG['base']['link_to_mainpage']['type'], CONFIG['base']['link_to_mainpage']['locator']).click
company_link = d.current_url
if company_link[-1].eql? '/'
  company_link = company_link[0...-1]
end

page = PageCreator.new(d, 'http://tt1.test3-yapokupayu.ru')
prod = ProductCreator.new(d,'http://tt1.test3-yapokupayu.ru',w)

prod.create_product
prod.create_product 'New product'

page.create_article
page.create_news
```
