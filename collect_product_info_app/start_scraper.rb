require_relative 'products_links.rb'
require_relative 'scraper_product_page.rb'
require_relative 'recorder.rb'
require 'curb'
require 'nokogiri'
require 'csv'

links = ProductsLinks.new(ARGV[0])
links.fetch_products_links

products = ScraperProductPage.new(links.products_links)
products.add_all_products
Recorder.record_to_file(ARGV[1], products.products_data)
