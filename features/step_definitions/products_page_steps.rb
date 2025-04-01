Then(/^I should see the products page$/) do
  Pages.products.assert_products_page_content
end

And(/^I (?:attempt to add|add) multiple items to the shopping cart$/) do
  Pages.products.add_items_to_cart
end

And(/^I add the two cheapest products to the shopping cart$/) do
  Pages.products.add_cheapest_items_to_cart
end

Then(/^I should see the items in the shopping cart$/) do
  Pages.products.assert_items_in_cart
end

Then(/^I should see no items in the shopping cart$/) do
  Pages.products.assert_no_items_in_cart
end