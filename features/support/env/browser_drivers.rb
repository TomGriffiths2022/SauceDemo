# browser-driver readme: https://github.com/dvla/dvla-browser-drivers/tree/main

require_relative 'config'
require_relative 'logger'

# Setting up the web browser config
driver = Settings.browser_config.driver
driver = "headless_#{driver}" if Settings.browser_config.headless
remote = Settings.browser_config.remote_host

DVLA::Browser::Drivers.send(driver, remote:)

Capybara.app_host = Settings.browser_config.app_host

LOG.info { "App Host: '#{Capybara.app_host}' | Driver: '#{Capybara.current_driver}' | Remote: '#{remote}'" }

Selenium::WebDriver.logger.level = :info if driver.to_s.include?('selenium')
