Feature: View match

As a GSOH user
I want to be able to view details about a match
So I can learn more about whether it's a good neighbourhood for me

@javascript
Scenario: View match
  Given I am signed in
  And there is a neighbourhood that matches part of my profile
  When I visit that neighbourhood's match page
  Then I should see a section of good and a section of bad
  And each section should contain appropriate features
  And features with more than 3 matches should be collapsed

@javascript
Scenario: Expand features
  Given I am signed in
  And there is a neighbourhood that matches part of my profile
  When I visit that neighbourhood's match page
  And I click the more link on a feature
  Then I should see the rest of the matches
  
