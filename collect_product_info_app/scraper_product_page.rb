# This class finds and stores products data
class ScraperProductPage
  attr_reader :add_all_products, :products_data
  def initialize(products_links)
    @products_links = products_links
    @products_data = []
  end

  def add_all_products
    print 'Извлекаю данные по товарам'
    @products_links.each do |link|
      print '.'
      nokogiri = Nokogiri::HTML.parse(download_web_page(link))
      add_product_data(nokogiri)
    end
    puts ''
    puts 'Готово'
  end

  private

  MULTIPRODUCT_CONTAINER_PATH = './/label[contains(@class, "label_comb_price")]'.freeze
  PRODUCT_NAME_PATH = './/h1[@class="product_main_name"]'.freeze
  PRODUCT_WEIGHT = './span[@class="radio_label"]'.freeze
  PRODUCT_PRICE = './span[@class="price_comb"]'.freeze
  PRODUCT_IMAGE = '//*[@id="bigpic"]/@src'.freeze

  def add_product_data(nokogiri)
    nokogiri.xpath(MULTIPRODUCT_CONTAINER_PATH).each do |product|
      pack_price = []
      pack_price << name_product(nokogiri) + ' - ' + product.xpath(PRODUCT_WEIGHT).text
      pack_price << product.xpath(PRODUCT_PRICE).text
      pack_price << product.xpath(PRODUCT_IMAGE).text
      @products_data << pack_price
    end
  end

  def download_web_page(link)
    Curl.get(link).body_str
  end

  def name_product(nokogiri)
    nokogiri.xpath(PRODUCT_NAME_PATH).text
  end
end
