module Locators
  module LoginPage
    PAGE_HEADER = '.login_logo'
    ERROR = 'h3[data-test="error"]'
    USERNAME = '#user-name'
    PASSWORD = '#password'
  end

  module ProductsPage
    PAGE_HEADER = '.app_logo'
    PAGE_SUBHEADING = '.title'
    ITEM = '.inventory_item'
    ITEM_NAME = '.inventory_item_name'
    ADD_TO_CART_BUTTON = '#add-to-cart-%<item_name>s'
    CART_ITEM = '.cart_item'
    CART = '.cart_list'
    CART_BUTTON = '.shopping_cart_link'
    ITEM_PRICE = '.inventory_item_price'
  end
end

