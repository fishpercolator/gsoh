
# This is a big one - make up a neighbourhood with a few hits and a few misses
Given(/^there is a neighbourhood that matches part of my profile$/) do
  user = User.find_by_email('test@example.com')
  features_that_match = %w{school pub pharmacy}
  features_that_dont_match = %w{restaurant doctors}
  
  # Make sure the user wants all the features on the list
  [features_that_match, features_that_dont_match].flatten.each do |ftype|
    create :importance_answer,
      user: user,
      question: create(:importance_question, ftype: ftype),
      answer: :essential
  end
  
  # Create an area with lots of just the matching features
  create :area_with_features, name: 'Wibbleton', ftypes: features_that_match, n_features: 15
end
