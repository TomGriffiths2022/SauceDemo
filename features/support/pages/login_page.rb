require_relative 'base_page'

class LoginPage < BasePage
  CONTENT = I18n.t('login_page')

  def enter_username(username:)
    element = begin
      # Find the username field
      find(Locators::LoginPage::USERNAME)
    rescue Capybara::ElementNotFound
      LOG.debug('Unable to find username field')
    end
    # Set the username
    element.set(username)
    self
  end

  def enter_password(password:)
    element = begin
      # Find the password field
      find(Locators::LoginPage::PASSWORD)
    rescue Capybara::ElementNotFound
      LOG.debug('Unable to find password field')
    end
    # Set the password
    element.set(password)
    self
  end

  def complete_form(role:)
    # Check if the role is a hash
    role = role.to_h if role.is_a? Config::Options

    enter_username(username: role.values.first[:username])
    enter_password(password: role.values.first[:password])
    self
  end

  def click_login
    begin
      # Click the login button
      page.click_link_or_button(CONTENT.dig(:buttons, :login))
    rescue Capybara::ElementNotFound
      LOG.debug('Unable to find continue button')
    end
  end

  def assert_error_message(error)
    # Check for the error message
    expect(page).to have_selector(Locators::LoginPage::ERROR)
    error_message = page.find(Locators::LoginPage::ERROR).text
    LOG.info("Error message: '#{error_message}'")
    # Assert the error message
    expect(error_message).to eq(error)
  end
end