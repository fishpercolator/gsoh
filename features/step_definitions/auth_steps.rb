Given(/^I am signed out$/) do
  page.driver.delete destroy_user_session_path
end

Given(/^I am signed in$/) do
  user = create :user, email: 'test@example.com', password: 'letmein123', password_confirmation: 'letmein123'
  visit new_user_session_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: user.password
  click_button 'Sign in'
end

When(/^I sign up for an account$/) do
  fill_in 'user_email', with: 'newuser@example.com'
  fill_in 'user_password', with: 'password'
  fill_in 'user_password_confirmation', with: 'password'
  click_button 'Sign up'
end

When(/^I click to advance without answering the question$/) do
  click_button 'Next'
end
