require 'gmo_click_bot/version'
require 'gmo_click_bot/config'
require 'gmo_click_bot/networking'
require 'gmo_click_bot/stock_factory'
require 'slack/post'
require 'integer_helper'
require 'pp'

module GmoClickBot
  def main
    self.slack_config
    stocks = StockFactory.createStocks
    stock_attachments = []
    stocks.each do |stock|
      stock_attachments << {
          text: "<http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{stock.code}|#{stock.code}: #{stock.name}>",
          fields: [
              {
                  title: '現在値',
                  value: "#{stock.price.to_jpy} x #{stock.num} = #{stock.sum_price.to_jpy}",
                  short: true,
              },
              {
                  title: '損益',
                  value: "#{stock.original_price.to_jpy} → #{stock.price.to_jpy} (#{stock.rate})",
                  short: true,
              },
          ],
          color: (stock.price - stock.original_price) > 0 ? '#d3edfb' : '#fadce9'
      }
    end
    self.slack_post_with_attachments('保有株式情報', stock_attachments)
  end

  def slack_config
    Slack::Post.configure(
        subdomain: Config['slack-subdomain'],
        token: Config['slack-token'],
        username: Config['slack-username'],
        parse: 'full',
    )
  end

  def slack_post_with_attachments(text, attachments)
    Slack::Post.post_with_attachments text, attachments, Config['slack-channel']
  end

  def slack_post(text)
    Slack::Post.post text, Config['slack-channel']
  end

  module_function :main
  module_function :slack_config
  module_function :slack_post
  module_function :slack_post_with_attachments
end
