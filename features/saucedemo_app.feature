Feature: SauceDemo App

  Description: The SauceDemo app should allow authorised users to login to the site and add products to the cart

  Scenario Outline: Authorised users can login to the site
    Given I am on the SauceDemo login page
    When I navigate to the 'products' page as an authorised user with '<username>'
    Then I should see the products page

    Examples:
      | username                |
      | standard_user           |
      | problem_user            |
      | performance_glitch_user |
      | error_user              |
      | visual_user             |

  @negative
  Scenario: Locked out user cannot login
    Given I am on the SauceDemo login page
    When I attempt to navigate to the 'products' page as a 'locked_out_user' user
    Then I should see the error message 'Epic sadface: Sorry, this user has been locked out.'

  Scenario Outline: Authorised users can add multiple items to the shopping cart
    Given I am on the SauceDemo login page
    When I navigate to the 'products' page as an authorised user with '<username>'
    And I add multiple items to the shopping cart
    Then I should see the items in the shopping cart

    Examples:
      | username                |
      | standard_user           |
      | performance_glitch_user |
      | error_user              |
      | visual_user             |

  @negative
  Scenario: Problem user cannot add items to cart
    Given I am on the SauceDemo login page
    When I attempt to navigate to the 'products' page as a 'problem_user' user
    And I attempt to add multiple items to the shopping cart
    Then I should see no items in the shopping cart

  Scenario Outline: Authorised users can add the two cheapest products to the cart
    Given I am on the SauceDemo login page
    When I navigate to the 'products' page as an authorised user with '<username>'
    And I add the two cheapest products to the shopping cart
    Then I should see the items in the shopping cart

    Examples:
      | username                |
      | standard_user           |
      | performance_glitch_user |
      | error_user              |
      | visual_user             |

