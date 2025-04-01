module HookHelpers
  def add_attachments(scenario_name:, feature_file:)
    report_generated_time = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
    attachments_directory = "./failure-reports/#{feature_file}/#{scenario_name}/#{report_generated_time}"

    FileUtils.mkdir_p("#{attachments_directory}/screenshots")
    FileUtils.mkdir_p("#{attachments_directory}/test-data")

    screenshot_path = "#{attachments_directory}/screenshots/#{report_generated_time}.png"
    test_data_path = "#{attachments_directory}/test-data/#{report_generated_time}.json"

    # Test data to be captured in the report of a failed test
    #   Example: { request: artefacts.request, uuid: artefacts.uuid }
    #   Warning! Do not use the entire artefacts object
    File.open(test_data_path, 'w') { |f| f.write(JSON.pretty_generate({})) }

    Capybara.save_screenshot(screenshot_path)
  end

  def accessibility
    LOG.info { "Checking accessibility on: '#{page.current_url}'" }

    step('the page should be axe clean')
  end
end

World(HookHelpers) # This mixes the above helper method into the World, allowing it to be accessed where it is needed
