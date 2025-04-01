When(/^I navigate to the '(.*)' page as an authorised user with '(.*)'$/) do |desired_page, username|
  # Map the possible users to an array
  possible_users = artefacts.authorised_users.map { |key, value| key }
  # Ensure the user is valid
  expect(possible_users.include?(username.to_sym)).to be(true)
  # Get the role details for the user
  role = artefacts.authorised_users.select { |key, value| key == username.to_sym }
  # Use the role details to navigate to the page
  Navigator.walk_to(desired_page:, artefacts:, role:)
end

When(/^I attempt to navigate to the '(.*)' page as a '(.*)' user$/) do |desired_page, username|
  # Map the possible users to an array
  possible_users = artefacts.authorised_users.map { |key, value| key }
  # Ensure the user is valid
  expect(possible_users.include?(username.to_sym)).to be(true)
  # Get the role details for the user
  role = artefacts.authorised_users.select { |key, value| key == username.to_sym }
  # Use the role details to navigate to the page
  Navigator.walk_to(desired_page:, artefacts:, role:)
end

Then(/^I should see the error message '(.*)'$/) do |error|
  # Check the error message is displayed
  Pages.login.assert_error_message(error)
end