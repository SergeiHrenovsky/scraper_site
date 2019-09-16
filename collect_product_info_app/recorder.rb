# This class record products data to the csv file
class Recorder
  def self.record_to_file(name_file, products_data)
    fetcher = new(name_file, products_data)
    fetcher.record_data
  end

  def initialize(name_file, products_data)
    @name_file = "#{name_file}.csv"
    @products_data = products_data
  end

  def record_data
    print "Записываю данные в файл #{@name_file}"
    CSV.open(@name_file, 'ab') { |csv| add_data(csv) }
    puts 'Готово'
    puts "Данные о товарах записаны в файл #{@name_file}"
  end

  private

  def add_data(csv)
    @products_data.each do |product_row|
      print '.'
      csv << product_row
    end
    puts ''
  end
end
