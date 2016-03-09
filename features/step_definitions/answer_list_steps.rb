When(/^I go to list answers$/) do
  visit answers_path
end

Then(/^I should see a list of (\d+) answers$/) do |arg1|
  expect(page).to have_css('.answer', count: arg1.to_i)
end

Then(/^they should be the answers I have given$/) do
  expect(page.first('.answer')).to have_content('A. Essential')
end
