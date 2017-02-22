class ProductCreator
  def initialize(driver, company_link, wait)
    @driver = driver
    @base_company_link = company_link
    @wait = wait
  end

  def create_product(name=nil, rubr=nil)
    rubric = rubr.nil? ? CONFIG['rubric'] : rubr
    @driver.navigate.to(@base_company_link + CONFIG['create_product_link'])
    pr_random = Random.new.rand(1..1000).to_s
    name = 'Test product ' + pr_random if name == nil
    @driver.find_element(CONFIG['create_product']['name']['type'], CONFIG['create_product']['name']['locator']).send_keys(name)
    self.search_rubric rubric
    @driver.find_element(CONFIG['create_product']['submit']['type'], CONFIG['create_product']['submit']['locator']).click
    return name
  end

  def search_rubric(rubric)
    @driver.find_element(CONFIG['create_product']['rubric_search']['type'], CONFIG['create_product']['rubric_search']['locator']).send_keys rubric
    @driver.find_element(CONFIG['create_product']['rubric_search_submit']['type'], CONFIG['create_product']['rubric_search_submit']['locator']).click
    search_result = @wait.until { @driver.find_element(CONFIG['create_product']['rubric']['type'], CONFIG['create_product']['rubric']['locator']) }
    search_result.click
  end

  def get_product_id(link)
    return link.split('/')[4].split('-')[0]
  end
end
