Given(/^there are (\d+) questions to answer$/) do |arg1|
  arg1.to_i.times {create :importance_question}
end

Given(/^I have answered (\d+) questions$/) do |arg1|
  user = User.find_by_email('test@example.com')
  arg1.to_i.times do
    q = user.unanswered_questions.first
    user.answer_question(q, :essential)
  end
end

When(/^I go to answer questions$/) do
  visit answer_questions_path
end

When(/^I answer the displayed question$/) do
  choose 'essential'
  step 'I click to go to the next question'
end

When(/^I click to go to the next question$/) do
  click_on 'Next'
end

Then(/^I should see a question with options$/) do
  expect(page).to have_css('div.well', text: '?')
  expect(page).to have_css('label.btn', count: 4)
end

Then(/^I should see a button for the next question$/) do
  expect(page).to have_css('button', text: 'Next')
end

Then(/^I should see there are (\d+) questions remaining$/) do |arg1|
  expect(page).to have_content("#{arg1.to_i} questions remaining")
end

Then(/^I should be told there are no more questions$/) do
  expect(page).to have_content('All questions answered')
end

Then(/^I should see an error telling me I haven't answered$/) do
  expect(page).to have_content('Answer must be set')
end
