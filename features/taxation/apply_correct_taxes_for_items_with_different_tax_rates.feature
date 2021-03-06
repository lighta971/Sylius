@cart
Feature: Apply correct taxes for items with different tax rates
    In order to pay proper amount when buying goods from different tax categories
    As a Visitor
    I want to have correct taxes applied to my order

    Background:
        Given the store operates on a single channel in "France"
        And default tax zone is "FR"
        And the store has "VAT" tax rate of 23% for "Clothes" within "FR" zone
        And the store has "Low VAT" tax rate of 5% for "Mugs" within "FR" zone
        And the store has a product "PHP T-Shirt" priced at "€100.00"
        And product "PHP T-Shirt" belongs to "Clothes" tax category
        And the store has a product "Symfony Mug" priced at "€50.00"
        And product "Symfony Mug" belongs to "Mugs" tax category

    @ui
    Scenario: Proper taxes for different taxed products
        When I add product "PHP T-Shirt" to the cart
        And I add product "Symfony Mug" to the cart
        Then my cart total should be "€175.50"
        And my cart taxes should be "€25.50"

    @ui
    Scenario: Proper taxes for multiple products with different tax rate
        When I add 3 products "PHP T-Shirt" to the cart
        And I add 4 products "Symfony Mug" to the cart
        Then my cart total should be "€579.00"
        And my cart taxes should be "€79.00"
