Feature: Sign up with question

As the product owner
I want to ask potential users a question before they sign up
So that they are enticed into using the product

Scenario: Question is displayed
  Given I am signed out
  And there are 4 questions to answer
  When I visit the homepage
  Then I should see a question with options
  
Scenario: Answer the question
  Given I am signed out
  And there are 4 questions to answer
  When I visit the homepage
  When I answer the displayed question
  Then I should be redirected to the sign up page
  
Scenario: Sign up with question answered
  Given I am signed out
  And there are 4 questions to answer
  When I visit the homepage
  When I answer the displayed question
  And I sign up for an account
  Then I should see a question with options
  And I should see a progress bar at 25%
  And I should see I have answered "1/4"

Scenario: Sign up without answering question
  Given I am signed out
  And there are 4 questions to answer
  When I visit the homepage
  When I click to advance without answering the question
  And I sign up for an account
  Then I should see a question with options
  And I should see a progress bar at 0%
  And I should see I have answered "0/4"
