@legacy_promotions
Feature: Checkout percentage discount promotions
    In order to handle product promotions
    As a store owner
    I want to apply promotion discounts during checkout

    Background:
        Given store has default configuration
        And the following promotions exist:
            | code | name    | description                                   |
            | PR1  | 3 items | 25% Discount for orders with at least 3 items |
            | PR2  | 300 EUR | 10% Discount for orders over 300 EUR          |
        And promotion "3 items" has following rules defined:
            | type       | configuration        |
            | item_count | Count: 3,Equal: true |
        And promotion "3 items" has following actions defined:
            | type                | configuration  |
            | percentage discount | percentage: 25 |
        And promotion "300 EUR" has following rules defined:
            | type       | configuration |
            | Item total | Amount: 300   |
        And promotion "300 EUR" has following actions defined:
            | type                | configuration  |
            | Percentage discount | percentage: 10 |
        And there are following taxonomies defined:
            | code | name     |
            | RTX1 | Category |
        And taxonomy "Category" has following taxons:
            | Clothing[TX1] > Debian T-Shirts[TX2] |
        And the following products exist:
            | name   | price | taxons          |
            | Buzz   | 500   | Debian T-Shirts |
            | Potato | 200   | Debian T-Shirts |
            | Woody  | 125   | Debian T-Shirts |
            | Sarge  | 25    | Debian T-Shirts |
            | Etch   | 20    | Debian T-Shirts |
            | Lenny  | 15    | Debian T-Shirts |
        And all products are assigned to the default channel
        And all promotions are assigned to the default channel

    Scenario: Percentage discount promotion is applied when the cart
            has the required amount
        Given I am on the store homepage
        When I add product "Etch" to cart, with quantity "4"
        Then I should be on the cart summary page
#        Valid scenario that is not passing, should follow '3 items' promotion
#          And "Promotion total: -€20.00" should appear on the page
#          And "Grand total: €60.00" should appear on the page

    Scenario: Percentage discount promotion is not applied when the cart
            has not the required amount
        Given I am on the store homepage
        When I add product "Sarge" to cart, with quantity "8"
        Then I should be on the cart summary page
#        8 items should follow '3 items' promotion
        And "Promotion total" should not appear on the page
        And "Grand total: €200.00" should appear on the page

    Scenario: Item count promotion is applied when the cart has the
            number of items required
        Given I am on the store homepage
        And I added product "Sarge" to cart, with quantity "3"
        And I added product "Etch" to cart, with quantity "1"
        When I add product "Lenny" to cart, with quantity "2"
        Then I should be on the cart summary page
#           125 - 25% * 125 = 93.75
        And "Promotion total: -€31.25" should appear on the page
        And "Grand total: €93.75" should appear on the page

    Scenario: Item count promotion is not applied when the cart has
            not the number of items required
        Given I am on the store homepage
        When I add product "Etch" to cart, with quantity "8"
        Then I should be on the cart summary page
#        8 items should follow '3 items' promotion
        And "Promotion total" should not appear on the page
        And "Grand total: €160.00" should appear on the page

    Scenario: Several promotions are applied when an cart fulfills
            the rules of several promotions
        Given I am on the store homepage
        And I added product "Potato" to cart, with quantity "4"
        And I added product "Buzz" to cart, with quantity "1"
        When I add product "Woody" to cart, with quantity "3"
        Then I should still be on the cart summary page
#        1675 - (10 + 25)% * 1675 = 586.25
        And "Promotion total: -€586.25" should appear on the page
        And "Grand total: €1,088.75" should appear on the page
