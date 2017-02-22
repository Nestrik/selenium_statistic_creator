class CompanyCreator
  def initialize (browser)
    @driver = browser
  end

  def create_company(name='Default company name')
    type = :css
    locator = '.js-text-field-comp-name'
    @driver.navigate.to(ST_CONFIG['portal_link'] + CONFIG['create_company_link'])
    @driver.find_element(CONFIG['create_company']['name']['type'], CONFIG['create_company']['name']['locator']).send_keys(name)
    @driver.find_element(CONFIG['create_company']['type']['type'], CONFIG['create_company']['type']['locator']).send_keys('test')
    random_num = Random.new.rand(10000..99999)
    @driver.find_element(CONFIG['create_company']['code']['type'], CONFIG['create_company']['code']['locator']).send_keys(random_num)
    @driver.find_element(CONFIG['create_company']['number']['type'], CONFIG['create_company']['number']['locator']).send_keys(random_num)

    @driver.find_element(CONFIG['create_company']['submit']['type'], CONFIG['create_company']['submit']['locator']).click
  end
end
