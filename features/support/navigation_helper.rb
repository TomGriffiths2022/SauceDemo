# Methods to help navigate the app
# Add new page to the POSSIBLE_PAGES array
# Add a 'when' statement with instructions on how to complete the page if necessary
require_relative './pages/base_page.rb'
module Navigator
  extend Capybara::DSL

module_function

  POSSIBLE_PAGES = %i[login products]

  def start_browsing_root
    visit(Capybara.app_host)
  end

  def get_current_page
    current_page = SimpleSymbolize.symbolize(Pages.base.current_path)
  end

   # Navigates to the request page, completing each screen as it goes along
   def walk_to(desired_page:, artefacts:, role: Settings.authorised_users.standard_user)
    desired_page = SimpleSymbolize.symbolize(desired_page)
    expect(POSSIBLE_PAGES.include?(desired_page)).to be(true)

    current_page = self.get_current_page

    if current_page.eql?(desired_page)
      LOG.info("On desired page: '#{desired_page}' page")
    else
      # Iterates through every page, completing the page until it gets to the one the test requires
      repeat(times: 15) do
        LOG.info("Navigating to: '#{desired_page}' page | On: '#{current_page}' page")

        case current_page
        when :login,
          LOG.info("Login as: '#{role.username}' user")
          Pages.login.complete_form(role:).click_login
        when :products
          # Implement if necessary to continue journey beyond this page
        else
          LOG.debug("Unknown page: '#{current_page}'")

          visit(Capybara.app_host)
        end
      end.until do
        current_page = self.get_current_page
        # Repeat until current page is the same as the desired page
        if current_page.eql?(desired_page)
          LOG.info("On desired page: '#{desired_page}' page")
        else
          false
        end
      end
    end
  rescue Net::ReadTimeout
    LOG.error('Net::ReadTimeout - re-trying step')

    visit(Capybara.app_host)
    walk_to(desired_page:, artefacts:)
  end
end