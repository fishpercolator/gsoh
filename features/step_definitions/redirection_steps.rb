Then(/^I should be redirected to the sign in page$/) do
  expect(current_path).to eq(new_user_session_path)
end

Then(/^I should be redirected to my matches$/) do
  expect(current_path).to eq(matches_path)
end

Then(/^I should be redirected to the answer questions page$/) do
  first_unanswered = User.find_by_email('test@example.com').unanswered_questions.first
  expect(current_path).to eq(edit_answer_path(first_unanswered.id))
end

Then(/^I should be told to sign in$/) do
  expect(page).to have_content('You need to sign in or sign up before continuing.')
end

Then(/^I should be told to answer questions$/) do
  expect(page).to have_content('No answers found. Please answer some questions below.')  
end
