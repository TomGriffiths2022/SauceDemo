class BasePage
  include RSpec::Matchers
  include Capybara::DSL


  # Returns common locale content located in config/locales/*.yml
  # @return [Hash]
  def common_content
    I18n.t('common')
  end

  # Returns the title of the page
  # Not to be confused with the page header which is typically an H1 element
  # @return [String]
  def get_page_title
    Capybara.title
  end


  # Find the element on the page
  # @param [String] text displayed on the link or button
  # @return [Capybara::Node::Element]
  def click_link_or_button(text: 'Continue')
    LOG.info { "Clicking link or button: '#{text}'" }

    Capybara.find(:link_or_button, text:, wait: 10).click
  end

  # Repeats an action a number of times until it succeeds
  # @yield the block to be repeated
  # @example
  #   repeatable_action { Capybara.find(:button, text: 'Continue').click }
  def repeatable_action(times: 3, delay: 0.5, &block)
    raise ArgumentError unless block

    repeat(times:, delay:) do
      begin
        yield
      rescue Selenium::WebDriver::Error::ElementClickInterceptedError, Capybara::ElementNotFound, Net::ReadTimeout => e
        LOG.error { e.message.red }

        visit_with_locale

        nil
      end
    end.until do |resp|
      expect(resp).not_to be_nil
    end
  end

  # Visits the current page with a specified locale
  # @param [Symbol] locale the locale to visit the page with
  # @example
  #   visit_with_locale(:en)
  def visit_with_locale(locale: I18n.locale)
    path = Capybara.current_path
    path_with_locale = "#{path}?locale=#{locale}"

    url = Capybara.current_url
    url = url.gsub(/\?locale=(?:en|cy)/, '').gsub(path, path_with_locale) unless url.include?(path_with_locale)

    LOG.debug { "Visiting: #{url}".red }

    Capybara.visit(url)
  end

  # Returns the current path of the page
  # @return [String]
  # @example
  #   current_path
  def current_path
    if page.current_path.split('/').last == nil
      return 'login'
    elsif page.current_path.split('/').last == 'inventory.html'
      return 'products'
    else
      page.current_path.split('/').last
    end
  end
end
