module GmoClickBot
  class Stock
    attr_reader :name, :code, :num, :price, :original_price, :rate
    def initialize(options = {})
      @name = options[:name]
      @code = options[:code]
      @num = options[:num]
      @price = options[:price]
      @original_price = options[:original_price]
      @rate = options[:rate]
    end

    def sum_price
      @price * @num
    end
  end
end