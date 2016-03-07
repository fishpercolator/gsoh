Given(/^there (?:is|are) (\d+) questions? to answer$/) do |arg1|
  arg1.to_i.times {create :importance_question}
end

Given(/^there (?:is|are) (\d+) boolean questions? to answer$/) do |arg1|
  arg1.to_i.times {create :boolean_question}
end

Given(/^there (?:is|are) (\d+) subtype questions? to answer$/) do |arg1|
  # Make sure there are subtypes to choose from
  %w{tom dick harry sally}.each {|st| create :feature, ftype: 'person', subtype: st}
  arg1.to_i.times {create :importance_question, ftype: 'person', ask_subtype: true}
end

Given(/^I have answered (\d+) questions?$/) do |arg1|
  user = User.find_by_email('test@example.com')
  arg1.to_i.times do
    q = user.unanswered_questions.first
    user.answer_question(q, :essential)
  end
end

When(/^I go to answer questions$/) do
  visit new_answer_path
end

When(/^I answer the displayed question(?: with '(\w+)')?$/) do |answer|
  choose answer || 'Essential'
  step 'I click to go to the next question'
end

When(/^I answer the displayed question selecting a subtype$/) do
  choose 'Essential'
  select 'Harry'
  step 'I click to go to the next question'
end

When(/^I click to go to the next question$/) do
  click_on 'Next'
end


Then(/^I should see a question with options$/) do
  expect(page).to have_css('#new_answer p', text: '?')
  expect(page).to have_css('#new_answer label.btn', count: 4)
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
  expect(page).to have_content("Answer can't be blank")
end

Then(/^I should be asked for a subtype$/) do
  expect(page).to have_select('answer_subtype', options: %w{Any Tom Dick Harry Sally})
end

Then(/^an answer should be recording containing the chosen subtype$/) do
  expect(Answer.where(subtype: 'harry').any?).to be true
end
