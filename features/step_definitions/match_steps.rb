Given(/^there exist (\d+) areas$/) do |arg1|
  arg1.to_i.times { create :area_with_features }
end

Given(/^I have answered some questions$/) do
  user = User.find_by_email('test@example.com')
  4.times { create :importance_answer, question: create(:importance_question), user: user, answer: :essential }
end

When(/^I list my matches$/) do
  visit matches_path
end

When(/^I click on a match$/) do
  link = page.first('#matchlist td a')
  @area = link.text
  link.click
end

Then(/^I should see (\d+) areas with match percentage$/) do |arg1|
  expect(page).to have_css('#matchlist tr', count: 4, text: /\d+%/)
end

Then(/^match percentages should be in descending order$/) do
  percentages = page.text.scan(/(\d+)%/).flatten.map(&:to_i)
  expect(percentages).to eq(percentages.sort.reverse)
end

Then(/^I should be taken to that area's match page$/) do
  expect(current_path).to eq(match_path area: @area)
end
