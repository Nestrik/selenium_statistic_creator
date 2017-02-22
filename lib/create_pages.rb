class PageCreator
  def initialize(driver, company_link, wait)
    @driver = driver
    @base_company_link = company_link
    @wait = wait
    rand = Random.new.rand(10..99)
  end

  def write_cke (text, locator = '//td/iframe')
    ckeditor_frame = @driver.find_element(:xpath, locator)
    @driver.switch_to.frame(ckeditor_frame)

    editor_body = @driver.find_element(:tag_name, 'body')
    editor_body.send_keys(text)
    @driver.switch_to.default_content
  end

  def create_newpage
    @driver.navigate.to (@base_company_link + '/pages/new')
    @driver.find_element(:css, '.js-field-title').send_keys('Test page: ' + rand.to_s)
    @driver.find_element(:css, '.original-button').click
  end

  def create_offer
    @driver.navigate.to (@base_company_link + '/sale/new')
    @driver.find_element(:css, '.cf-text-filed').send_keys('Test sale: ' + rand.to_s)
    @driver.find_element(:css, '.js-deal-price').send_keys('50')
    @driver.find_element(:css, '.js-deal-discount').send_keys('50')

    #dissable readonly attribute on elements
    @driver.execute_script("document.getElementById('offer_start_date').removeAttribute('readonly',0)")
    @driver.find_element(:css, '.js-deal-duration-start').send_keys("01/01/2017")
    @driver.execute_script("document.getElementById('offer_end_date').removeAttribute('readonly',0)")
    @driver.find_element(:css, '.js-deal-duration-end').send_keys("31/12/2017")

    #ckeditor sendings
    self.write_cke("Text for description of offer")

    #submit
    @driver.find_element(:css, '.middle').click
  end

  def create_news
    @driver.navigate.to (@base_company_link + '/news/new')
    @driver.find_element(:id, 'news_title').send_keys('Test news: ' + rand.to_s)
    @driver.find_element(:class, 'uf-ta').send_keys('Test description of news ' + rand.to_s)
    self.write_cke('Some text in body of news')
    @driver.find_element(:class, 'uf-sbm').click
  end

  def create_article
    @driver.navigate.to (@base_company_link + '/articles/new')
    @driver.find_element(:id, 'article_title').send_keys('Test article: ' + rand.to_s)
    @driver.find_element(:class, 'uf-ta').send_keys('Test description of article ' + rand.to_s)
    self.write_cke('Some text in body of article')
    @driver.find_element(:class, 'uf-sbm').click
  end
end
