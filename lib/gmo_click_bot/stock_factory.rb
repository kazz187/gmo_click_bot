require 'gmo_click_bot/networking'
require 'gmo_click_bot/stock'

module GmoClickBot
  class StockFactory
    def self.createStocks
      Networking.instance.login
      agent = Networking.instance.get('/kabu/genPositionList.do')
      tables = agent.page.search('table')
      sum = clean(tables[1].search('tr/td')[1].children)
      stock_info = tables[3].search('tr').drop(1)
      stocks = []
      stock_info.each do |tr|
        td_list = tr.search('td')
        stocks << td_list_to_stock(td_list)
      end
      stocks
    end

    private
    def self.clean(str)
      str.text.split("\n").map{|s|s.strip}.join
    end

    def self.td_list_to_stock(td)
      options = {
          name:  clean(td[1].search('a')[0].children[0]),
          code:  clean(td[1].search('a')[0].children[2]),
          price: clean(td[4].children[0]).gsub(/(\d{0,3}),(\d{3})/, '\1\2').to_i,
          num:   clean(td[2].children[0]).gsub(/(\d{0,3}),(\d{3})/, '\1\2').to_i,
          original_price: clean(td[3].children[0]).gsub(/(\d{0,3}),(\d{3})/, '\1\2').to_i,
          rate: clean(td[5].children[5]).gsub(/\((.+?)\)/, '\1'),
      }
      Stock.new(options)
    end
  end
end