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
  And I should see a button to skip this question
  And I should see a progress bar at 0%
  And I should see I have 4 questions remaining

Scenario: Answering a question
  Given I am signed in
  And there are 4 questions to answer
  And I have answered 0 questions
  When I go to answer questions
  And I answer the displayed question
  Then I should see a question with options
  And I should see a progress bar at 25%
  And I should see I have 3 questions remaining
  
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

Scenario: Answering boolean question
  Given I am signed in
  And there is 1 boolean question to answer
  And I have answered 0 questions
  When I go to answer questions
  And I answer the displayed question with 'No'
  Then I should be redirected to my matches
  And I should be told there are no more questions
  
Scenario: Subtype question asks about subtype
  Given I am signed in
  And there is 1 subtype question to answer
  And I have answered 0 questions
  When I go to answer questions
  Then I should be asked for a subtype
  
Scenario: Answering subtype question
  Given I am signed in
  And there is 1 subtype question to answer
  And I have answered 0 questions
  When I go to answer questions
  And I answer the displayed question selecting a subtype
  Then I should be redirected to my matches
  And I should be told there are no more questions
  And an answer should be recording containing the chosen subtype

Scenario: Skip question
  Given I am signed in
  And there are 4 questions to answer
  And I have answered 0 questions
  When I go to answer questions
  And I click to skip
  Then I should see the second question
