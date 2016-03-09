Feature: List answers

As a GSOH user
I want to be able to list the answers I've already given
In order to remind myself why areas are matching

Scenario: Signed out
  Given I am signed out
  When I go to list answers
  Then I should be redirected to the sign in page
  And I should be told to sign in

Scenario: Signed in, answered questions
  Given I am signed in
  And there are 4 questions to answer
  And I have answered 3 questions
  When I go to list answers
  Then I should see a list of 3 answers
  And they should be the answers I have given

Scenario: Signed in, no questions answered
  Given I am signed in
  And there are 4 questions to answer
  And I have answered 0 questions
  When I go to list answers
  Then I should be redirected to the answer questions page
  And I should be told to answer questions

Scenario: Answer list has edit button
  Given I am signed in
  And there are 4 questions to answer
  And I have answered 3 questions
  When I go to list answers
  Then I should see an edit button on each answer
  When I click on an edit button
  Then I should be redirected to the edit answer page
