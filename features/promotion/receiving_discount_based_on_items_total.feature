@promotion
Feature: Receiving discount based on items total
    In order to pay decreased amount for my order during promotion
    As a Visitor
    I want to have promotion applied when my items total is qualified

    Background:
        Given the store is operating on a single "France" channel
        And the store has a product "PHP T-Shirt" priced at "€80.00"
        And there is a promotion "Holiday promotion"

    @todo
    Scenario: Receiving discount when buying items for the required total value
        Given the promotion gives "€10.00" fixed discount to every cart with items total at least "€80.00"
        When I add product "PHP T-Shirt" to the cart
        Then my cart total should be "€70.00"
        And my discount should be "-€10.00"

    @todo
    Scenario: Receiving discount when buying items for more than required total value
        Given the promotion gives "€10.00" fixed discount to every cart with items total at least "€90.00"
        When I add 2 products "PHP T-Shirt" to the cart
        Then my cart total should be "€150.00"
        And my discount should be "-€10.00"

    @todo
    Scenario: Not receiving discount when buying items for less than required total value
        Given the promotion gives "€10.00" fixed discount to every cart with items total at least "€100.00"
        When I add product "PHP T-Shirt" to the cart
        Then my cart total should be "€80.00"
        And my discount should be "€0.00"

    @todo
    Scenario: Receiving discount when buying different products for more than the required total value
        Given the store has a product "Symfony T-Shirt" priced at "€60.00"
        And the promotion gives "€10.00" fixed discount to every cart with items total at least "€200.00"
        When I add 2 products "PHP T-Shirt" to the cart
        And I add product "Symfony T-Shirt" to the cart
        Then my cart total should be "€210.00"
        And my discount should be "-€10.00"
