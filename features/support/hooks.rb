Before('@wip or @manual') do |_scenario|
  skip_this_scenario
end

Before do |scenario|
  LOG.new_scenario(scenario.id)
  LOG.info { "Running Scenario: #{scenario.name}" }
end

After do |scenario|
  tags = scenario.source_tag_names

  unless %w[@wip @manual @skip].any? { |tag| tags.include?(tag) }
    if scenario.failed?
      LOG.info { 'Scenario Failed - Taking screenshot & attaching test_data' }
      LOG.info { "Current URL: #{current_url}" }

      add_attachments(scenario_name: scenario.name.slice(0..23), feature_file: scenario.location.file.split('/').last)
    elsif Settings.test.accessibility && !tags.include?('@no_accessibility')
      accessibility
    end
  end

  LOG.info { "Finished running: '#{scenario.name}' from '#{scenario.location.file}'" }
ensure
  Capybara.reset_sessions!
end
