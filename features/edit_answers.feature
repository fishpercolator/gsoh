Feature: Edit answers

As a GSOH user
I want to be able to edit my answers
Because sometimes I change my mind

Scenario: Edit an existing answer
  Given I am signed in
  And there are 4 questions to answer
  And I have answered 1 question
  When I go to edit an answer
  Then I should see my existing answer selected
  When I change my answer and save
  Then my new answer should be recorded
  And I should redirected to the answers page
  And I should be told my new answer was saved
  
Scenario: Edit a subtype answer
