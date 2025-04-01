Bundler.require
require 'axe-cucumber-steps'
require 'capybara/dsl'

require_relative './pages/base_page.rb'
require_relative './pages.rb'

include RSpec::Matchers
include BlockRepeater
World(Capybara::DSL)

# enable env overrides
Config.use_env = true
Config.env_separator = '__'
Config.env_parse_values = true
Config.load_and_set_settings(Config.setting_files('./config', 'settings'))

# Locale setup for I18n
I18n.config.available_locales = %i[en cy en-GB]
I18n.load_path += (Dir[File.expand_path('config/locale/*.yml')])
I18n.default_locale = :en
Dir['env'].each { |file| require file }
# Dir['env/*.rb'].each { |path| require_relative(path) }

# Taking into consideration the execution environment
supported_executions = %i[local drone docker]
execution = SimpleSymbolize.symbolize(Settings.browser_config.execution)
browser = SimpleSymbolize.symbolize(Settings.browser_config.driver)

raise "Unsupported execution: '#{execution}'" unless supported_executions.include?(execution)

# CI/CD environment
# If running in a CI/CD environment, use the headless driver
docker_env = %i[drone docker].include?(execution)

if Settings.browser_config.headless || docker_env
  case browser
  when :edge
    DVLA::Browser::Drivers.headless_selenium_edge
  when :firefox
    DVLA::Browser::Drivers.headless_selenium_firefox
  else
    DVLA::Browser::Drivers.headless_selenium_chrome
  end
else
  DVLA::Browser::Drivers.selenium_chrome
end

BlockRepeater::Repeater.default_catch(exceptions: [RSpec::Expectations::ExpectationNotMetError], behaviour: :defer, &:raise)


