Feature: Get matches

As a GSOH user
I want to see a list of neighbourhoods that match my profile
So that I can find out which neighbourhoods are best to live in

Scenario: No account
  Given I am signed out
  When I list my matches
  Then I should be redirected to the sign in page
  And I should be told to sign in
  
Scenario: Listing matches
  Given I am signed in
  And there exist 4 areas
  And I have answered some questions
  When I list my matches
  Then I should see 4 areas with match percentage
  And match percentages should be in descending order
  
Scenario: Proceeding to match details
  Given I am signed in
  And there exist 4 areas
  And I have answered some questions
  When I list my matches
  And I click on a match
  Then I should be taken to that area's match page
