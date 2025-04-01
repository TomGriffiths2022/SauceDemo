require_relative 'base_page'

class ProductsPage < BasePage
  CONTENT = I18n.t('products_page')

  def get_page_header
    Capybara.find(Locators::ProductsPage::PAGE_HEADER).text
  end

  def get_page_subheading
    Capybara.find(Locators::ProductsPage::PAGE_SUBHEADING).text
  end

  def assert_products_page_content
    LOG.info('Asserting products page content')
    assert_page_title(CONTENT.dig(:title))
    assert_page_header(CONTENT.dig(:header))
    assert_page_subheading(CONTENT.dig(:sub_heading))
  end

  def assert_page_title(expected_title)
    actual_title = get_page_title
    LOG.info("Expected title: '#{expected_title}'")
    LOG.info("Actual title: '#{actual_title}'")

    expect(actual_title).to eq(expected_title)
  end

  def assert_page_header(expected_header)
    actual_header = get_page_header
    LOG.info("Expected header: '#{expected_header}'")
    LOG.info("Actual header: '#{actual_header}'")

    expect(actual_header).to eq(expected_header)
  end

  def assert_page_subheading(expected_subheading)
    actual_subheading = get_page_subheading
    LOG.info("Expected subheading: '#{expected_subheading}'")
    LOG.info("Actual subheading: '#{actual_subheading}'")

    expect(actual_subheading).to eq(expected_subheading)
  end

  def add_items_to_cart
    LOG.info('Adding items to cart')
    items = find_items_to_add
    items.each do |item|
      add_to_cart(item)
    end
  end

  def find_items_in_cart
    Capybara.all(Locators::ProductsPage::CART_ITEM).map do |item|
      item_name = item.find(Locators::ProductsPage::ITEM_NAME).text
      in_cart = item[:class].include?('cart_item')
      { name: item_name, in_cart: }
    end
  end

  def assert_items_in_cart
    LOG.info('Asserting items in cart')
    # Click the cart button to view the items in the cart
    Capybara.find(Locators::ProductsPage::CART_BUTTON).click
    # Wait for the cart items to load
    Capybara.find(Locators::ProductsPage::CART)
    # Check if the items are in the cart
    items = find_items_in_cart
    if items.empty?
      LOG.error('No items found in the cart')
    else
      items.each do |item|
        expect(item[:in_cart]).to be true
      end
    end
  end

  def assert_no_items_in_cart
    LOG.info('Asserting no items in cart')
    # Click the cart button to view the items in the cart
    Capybara.find(Locators::ProductsPage::CART_BUTTON).click
    # Check if the items are in the cart
    items = find_items_in_cart
    expect(items.empty?).to be true
  end

  def find_items_to_add
    items = []
    Capybara.all(Locators::ProductsPage::ITEM).each do |item|
      # Find the item name and price
      item_name = item.find(Locators::ProductsPage::ITEM_NAME).text
      add_to_cart_button = find_add_to_cart_button(item_name)
      price = item.find(Locators::ProductsPage::ITEM_PRICE).text
      # Remove the dollar sign and convert to float
      price = price.delete('$').to_f
      # Check if the item is already in the cart
      in_cart = item[:class].include?('cart_item')
      # If the item is already in the cart, skip it
      next if in_cart
      # If the item is not in the cart, add it to the list
      # If the add to cart button is not clickable, skip it
      if add_to_cart_button.nil?
        LOG.debug("Unable to find add to cart button for '#{item_name}'")
        add_to_cart_button = true
      end
      # Add the item to the list
      LOG.info("Item: '#{item_name}' | Price: '#{price}'")
      LOG.info("Add to cart button: '#{add_to_cart_button}'")
      # Check if the item is already in the cart
      items << { name: item_name, in_cart: false, button: add_to_cart_button, price: }
    end
    items
  end

  def add_to_cart(item)
    LOG.info("Adding '#{item[:name]}' to cart")
    unless item[:button] == true # if the button is not clickable, i.e. no clickable element found by find_add_to_cart_button
      item[:button].click
      item[:in_cart] = true
      LOG.info("Added '#{item[:name]}' to cart")
    else
      LOG.error("Unable to find add to cart button for '#{item[:name]}'")
    end
  end

  def add_cheapest_items_to_cart
    LOG.info('Adding cheapest items to cart')
    items = find_items_to_add
    # Sort items by price
    items.sort_by! do |item|
      item[:price]
    end
    # Select the two cheapest items
    cheapest_items = items.first(2)
    # Add the cheapest items to the cart
    LOG.info("Cheapest items: #{cheapest_items.map { |item| item[:name] }}")
    # Click the add to cart button for each item  
    cheapest_items.each do |item|
      add_to_cart(item)
    end
  end

  def find_add_to_cart_button(item_name)
    item_name = item_name.downcase.tr(' ', '-')
    LOG.info("Finding add to cart button for '#{item_name}'")
    # Use the item name to find the button
    begin
      Capybara.find(Locators::ProductsPage::ADD_TO_CART_BUTTON % {item_name:})
    rescue Selenium::WebDriver::Error::InvalidSelectorError => e
      LOG.debug { e.message }
    end
  end

end