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

When(/^I visit that neighbourhood's match page$/) do
  visit match_path(area: 'Wibbleton')
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

Then(/^I should see a section of good and a section of bad$/) do
  expect(page).to have_css('h2 span.good')
  expect(page).to have_css('h2 span.bad')
end

Then(/^each section should contain appropriate features$/) do
  %w{School Pub Pharmacy}.each do |ftype|
    expect(page.find('.good-answers')).to have_text(ftype)
    expect(page.find('.bad-answers')).not_to have_text(ftype)
  end
  %w{Restaurant Doctors}.each do |ftype|
    expect(page.find('.good-answers')).not_to have_text(ftype)
    expect(page.find('.bad-answers')).to have_text(ftype)
  end
end

def get_popular_ftype
  user = User.find_by_email('test@example.com')
  area = Area.find_by_name('Wibbleton')
  match = Match.new(user: user, area: area, score: 50)
  answer = match.good_answers.find {|a| a.area_matching_features(area).length > 3}
  # memoize the response for speed
  @response ||= [answer.question.ftype, answer.area_matching_features(area).map(&:name)]
end

Then(/^features with more than 3 matches should be collapsed$/) do
  ftype, features = get_popular_ftype
  within(page.find('tr', text: ftype.capitalize)) do
    assert_text 'more'
    assert_text features[0]
    assert_no_text features[3]
  end
end

When(/^I click the more link on a feature$/) do
  ftype, features = get_popular_ftype
  within(page.find('tr', text: ftype.capitalize)) do
    click_link('more')
  end
end

Then(/^I should see the rest of the matches$/) do
  ftype, features = get_popular_ftype
  within(page.find('tr', text: ftype.capitalize)) do
    assert_text features[0]
    assert_text features[3]
  end
end
