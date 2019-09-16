# This class finds and stores links to products in a given category
class ProductsLinks
  attr_reader :fetch_products_links, :products_links
  def initialize(category_link)
    @category_link = category_link
    @products_links = []
  end

  def fetch_products_links
    products_links = []
    (1..fetch_sum_pages).each do |num_page|
      puts "Сканирую #{num_page} страницу в выбранной категории"
      num_page == 1 ? link_page_category = @category_link : link_page_category = @category_link + "?p=#{num_page}"
      add_products_links_current_page(link_page_category)
      puts "Готово"
    end
    puts "Все ссылки на товары в выбранной категории найдены"
  end

  private

  SUM_PRODUCTS_IN_CATEGORY_XPATH = '//*[@id="center_column"]/span'
  PRODUCTS_LINKS_XPATH = '//*[@id="product_list"]/li/div[1]/div/div[1]/a'
  SUM_PRODUCTS_ON_ONE_PAGE = 25.0

  def download_web_page(link)
    Curl.get(link).body_str
  end
    
  def fetch_sum_products
    nokogiri = Nokogiri::HTML.parse(download_web_page(@category_link))
    nokogiri.xpath(SUM_PRODUCTS_IN_CATEGORY_XPATH).text[%r|[0-9]*|].to_f
  end

  def fetch_sum_pages
    puts 'Ищу ссылки на товары в выбранной категории'
    (fetch_sum_products / SUM_PRODUCTS_ON_ONE_PAGE).ceil
  end

  def add_products_links_current_page(link_page_category)
    nokogiri = Nokogiri::HTML.parse(download_web_page(link_page_category))
    current_products_links = nokogiri.xpath(PRODUCTS_LINKS_XPATH)
    current_products_links.each do |link|
      @products_links << link[:href]
    end
  end
end
