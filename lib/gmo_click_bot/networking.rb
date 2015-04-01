require 'singleton'
require 'mechanize'
require 'logger'

module GmoClickBot
  class Networking
    include Singleton

    def initialize
      @agent = Mechanize.new
      @agent.user_agent_alias = 'Windows Mozilla'
      @agent.log = Logger.new(File.join(Config['log_dir'], 'gmo_click_agent.log'))
      @agent.log.level = Logger::INFO
      @agent.max_history = 1
      yield self if block_given?
    end

    def get(page_name)
      @agent.get("https://kabu.click-sec.com/#{@sec}#{page_name}")
      @agent
    end

    def login
      @agent.get('https://sec-sso.click-sec.com/loginweb/sso-redirect') { |page|
        unless login?
          page.form_with(:name => 'loginForm') { |form|
            form.field_with(:name => 'j_username').value = Config['username']
            form.field_with(:name => 'j_password').value = Config['password']
            form.click_button
          }
          @sec = @agent.page.uri.to_s.scan(/\/(sec[0-9a-f]+-[0-9a-f]+)\//)[0][0]
        end
      }
      raise 'Failed to login' unless login?
    end

    def login?
      @agent.page and @sec
    end
  end
end