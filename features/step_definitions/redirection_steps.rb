Then(/^I should be redirected to the sign in page$/) do
  expect(current_path).to eq(new_user_session_path)
end

Then(/^I should be redirected to my matches$/) do
  expect(current_path).to eq(matches_path)
end
