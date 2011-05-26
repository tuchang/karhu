Feature: Products
  In order to know which products I have
  As a user
  I want to manage products
  
  Background:
    Given I am logged in
  
  Scenario: list products
    Given a category "Baeume" with the description "Grosse Pflanzen"
      And a product "Fichte" with the description "Nadelbaum" and the price "232.00$" that is valid to "12/20/2027" and belongs to the category "Baeume"
      And a product "Birke" with the description "Laubbaum" and the price "115.75$" that is valid to "03/01/2019" and belongs to the category "Baeume"
    When I go to the start page
      And I follow "Products"
    Then I should see "Baeume"
      And I should see "Fichte"
      And I should see "Nadelbaum"
      And I should see "232.00$"
      And I should see "12/20/2027"
      And I should see "Birke"
  
  Scenario: create product
    Given a category "Baeume" with the description "Grosse Pflanzen"
    When I go to the start page
      And I follow "Products"
      And I follow "Add Product"
      And I fill in "Name" with "Tanne"
      And I fill in "Description" with "Nadelbaum"
      And I fill in "Price" with "345.05$"
      And I fill in "Valid To" with "04/04/2035"
      And I select "Baeume" from "Category"
      And I press "Add Product"
    Then I should see "Tanne"
      And I should see "Nadelbaum"
      And I should see "345.05$"
      And I should see "04/04/2035"
      And I should see "Baeume"

  Scenario: create product when offline
    Given a category "Baeume" with the description "Grosse Pflanzen"
      And a product "Fichte" with the description "Nadelbaum" and the price "232.00$" that is valid to "12/20/2027" and belongs to the category "Baeume"
    When I go to the start page
      And I wait for 3s
      And I get disconnected from the internet
      And I follow "Products"
      And I follow "Add Product"
      And I fill in "Name" with "Tanne"
      And I fill in "Description" with "Nadelbaum"
      And I fill in "Price" with "345.05$"
      And I fill in "Valid To" with "04/04/2035"
      And I select "Baeume" from "Category"
      And I press "Add Product"
      And I follow "Add Product"
      And I fill in "Name" with "Kiefer"
      And I fill in "Description" with "Nadelbaum"
      And I fill in "Price" with "227.25$"
      And I fill in "Valid To" with "01/08/2029"
      And I select "Baeume" from "Category"
      And I press "Add Product"
    Then I should see "Fichte"
      And I should see "Tanne"
      And I should see "Kiefer"
    When I get connected to the internet
    Then the api should have received a call to create a product with the name "Tanne"
      And the api should have received a call to create a product with the name "Kiefer"

  Scenario: create product fails because of validation errors
    Given a category "Baeume" with the description "Grosse Pflanzen"
    When I go to the start page
      And I follow "Products"
      And I follow "Add Product"
      And I fill in "Description" with "Nadelbaum"
      And I fill in "Price" with "345.05$"
      And I fill in "Valid To" with "04/04/2035"
      And I select "Baeume" from "Category"
      And I press "Add Product"
    Then I should see "cannot be empty"
  
  Scenario: create product fails because of invalid date for the current locale
    Given a category "Baeume" with the description "Grosse Pflanzen"
    When I go to the start page
      And I follow "Products"
      And I follow "Add Product"
      And I fill in the product details for "Tanne"
      And I fill in "Valid To" with "04.04.2035"
      And I press "Add Product"
    Then I should see "wrong format"
    When I fill in "Valid To" with "04/04/2035"
      And I press "Add Product"
    Then I should see "Tanne"
    When I follow "Deutsch"
      And I follow "Produkt hinzufügen"
      And I fill in "Name" with "Kiefer"
      And I fill in "Beschreibung" with "Nadelbaum"
      And I fill in "Preis" with "345,05€"
      And I fill in "Gültig bis" with "04/04/2035"
      And I press "Produkt hinzufügen"
    Then I should see "falsches Format"
    When I fill in "Gültig bis" with "04.04.2035"
      And I press "Produkt hinzufügen"
    Then I should see "Tanne"
      And I should see "Kiefer"
    When I follow "English"

  Scenario: create product fails because of invalid price for the current locale
    Given a category "Baeume" with the description "Grosse Pflanzen"
    When I go to the start page
      And I follow "Products"
      And I follow "Add Product"
      And I fill in the product details for "Tanne"
      And I fill in "Price" with "300,00€"
      And I press "Add Product"
    Then I should see "wrong format"
    When I fill in "Price" with "300.00$"
      And I press "Add Product"
    Then I should see "Tanne"
    When I follow "Deutsch"
      And I follow "Produkt hinzufügen"
      And I fill in "Name" with "Kiefer"
      And I fill in "Beschreibung" with "Nadelbaum"
      And I fill in "Preis" with "300.00$"
      And I fill in "Gültig bis" with "04.04.2035"
      And I press "Produkt hinzufügen"
    Then I should see "falsches Format"
    When I fill in "Preis" with "300,00€"
      And I press "Produkt hinzufügen"
    Then I should see "Tanne"
      And I should see "Kiefer"
    When I follow "English"
      
  Scenario: delete product
    Given a category "Baeume" with the description "Grosse Pflanzen"
      And a product "Fichte" with the description "Nadelbaum" and the price "232.00$" that is valid to "12/20/2027" and belongs to the category "Baeume"
    When I go to the start page
      And I follow "Products"
    Then I should see "Fichte" within ".products_table"
    When I press "delete"
    Then I should not see "Fichte" within ".products_table"
  
  Scenario: edit product
    Given a category "Alphabete" with the description "ABC"
      And a category "Baeume" with the description "Grosse Pflanzen"
      And a product "Fichte" with the description "Nadelbaum" and the price "232.00$" that is valid to "12/20/2027" and belongs to the category "Baeume"
    When I go to the start page
      And I follow "Products"
      And I follow "edit"
    Then "Baeume" should be the selected "Category"
    When I fill in "Description" with "Gruen"
      And I press "Update Product"
    Then I should see "Fichte"
      And I should see "Gruen"
      But I should not see "Nadelbaum"

  Scenario: edit product when offline
    Given a category "Baeume" with the description "Grosse Pflanzen"
      And a product "Fichte" with the description "Nadelbaum" and the price "232.00$" that is valid to "12/20/2027" and belongs to the category "Baeume"
      And a product "Tanne" with the description "Nadelbaum" and the price "232.00$" that is valid to "12/20/2027" and belongs to the category "Baeume"
    When I go to the start page
      And I wait for 3s
      And I get disconnected from the internet
      And I follow "Products"
      And I follow "Edit Fichte"
      And I fill in "Description" with "F.I.C.H.T.E."
      And I press "Update Product"
      And I follow "Add Product"
      And I fill in the product details for "Kiefer"
      And I press "Add Product"
      And I follow "Edit Tanne"
      And I fill in "Description" with "T.A.N.N.E."
      And I press "Update Product"
    Then I should see "Fichte"
      And I should see "F.I.C.H.T.E."
      And I should see "Kiefer"
      And I should see "Tanne"
      And I should see "T.A.N.N.E."
    When I get connected to the internet
      And the api should have received a call to create a product with the name "Kiefer"
      And the api should have received a call to update a product with the name "Fichte" and the new description "F.I.C.H.T.E."
      And the api should have received a call to update a product with the name "Tanne" and the new description "T.A.N.N.E."
  