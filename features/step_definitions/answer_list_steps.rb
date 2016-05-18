When(/^I go to list answers$/) do
  visit answers_path
end

When(/^I click on an edit button$/) do
  within first('.answer-well') do
    click_on 'Edit'
  end
end

Then(/^I should see a list of (\d+) answers$/) do |arg1|
  expect(page).to have_css('.answer-well', count: arg1.to_i)
end

Then(/^they should be the answers I have given$/) do
  expect(page.first('.answer-well')).to have_content('A. Important')
end

Then(/^I should see an edit button on each answer$/) do
  expect(page).to have_css('a', text: 'Edit', count: 3)
end

Then(/^I should (not )?see an invitation to answer more questions$/) do |neg|
  match = have_content('Answer more')
  if neg
    expect(page).not_to match
  else
    expect(page).to match
  end
end
