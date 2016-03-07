Feature: Answer questions

As a GSOH user
I want to answer questions about my preferences
So GSOH has a better idea about me for generating matches

Scenario: No account
  Given I am signed out
  When I go to answer questions
  Then I should be redirected to the sign in page
  And I should be told to sign in

Scenario: Presented with a question
  Given I am signed in
  And there are 4 questions to answer
  And I have answered 0 questions
  When I go to answer questions
  Then I should see a question with options
  And I should see a button for the next question
  And I should see there are 4 questions remaining

Scenario: Answering a question
  Given I am signed in
  And there are 4 questions to answer
  And I have answered 0 questions
  When I go to answer questions
  And I answer the displayed question
  Then I should see a question with options
  And I should see there are 3 questions remaining
  
Scenario: Answering the final question
  Given I am signed in
  And there are 4 questions to answer
  And I have answered 3 questions
  When I go to answer questions
  And I answer the displayed question
  Then I should be redirected to my matches
  And I should be told there are no more questions
  
Scenario: Trying to answer questions when none remain
  Given I am signed in
  And there are 4 questions to answer
  And I have answered 4 questions
  When I go to answer questions
  Then I should be redirected to my matches
  And I should be told there are no more questions

Scenario: Proceeding without answering
  Given I am signed in
  And there are 4 questions to answer
  And I have answered 0 questions
  When I go to answer questions
  And I click to go to the next question
  Then I should see an error telling me I haven't answered
