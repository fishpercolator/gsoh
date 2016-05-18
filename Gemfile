source 'https://rubygems.org'

ruby '2.3.1'

gem 'dotenv-rails', groups: [:development, :test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.1'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Puma as the app server
gem 'puma', '~> 3.2'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Frameworky stuff
gem 'administrate', '~> 0.2.0', github: 'thoughtbot/administrate'
gem 'bootstrap-sass', '~> 3.3'
gem 'bootswatch-rails', '~> 3.3'
gem 'bootstrap-select-rails', '~> 1.6'
gem 'devise', '~> 4.1'
gem 'devise-bootstrap-views', '~> 0.0.8'
gem 'omniauth-facebook', '~> 3.0'
gem 'omniauth-twitter', '~> 1.2'
gem 'haml-rails', '~> 0.9.0'
gem 'high_voltage', '~> 2.4'
gem 'pundit', '~> 1.1'
gem 'administrate-field-password', '~> 0.0.2'
gem 'administrate-field-type', '~> 1.0'
gem 'administrate-field-lat_lng', '~> 1.0'
# just until https://github.com/thoughtbot/administrate/issues/561 is resolved
gem 'administrate-field-image', '~> 0.0'
gem 'kaminari', '~> 0.16.3'
gem 'postmark-rails', '~> 0.12.0'
gem 'google-analytics-rails', '~> 1.1'
gem 'gon', '~> 6.0'

# Needed for the seeding of data from OpenStreetMap
gem 'overpass-api-ruby', '~> 0.1.3'
gem 'retriable', '~> 2.1'

# For drawing maps in the UI
gem 'leaflet-rails', '~> 0.7.7'
gem 'color-generator', '~> 0.0.4'

# For querying government data
gem 'ckan', '~> 0.0.3', github: 'fishpercolator/CKAN'
gem 'breasal', '~> 0.0.1'

# So the objects can be mappable
gem 'geokit-rails', '~> 2.1'

# For dumping prod DB to dev
gem 'seed_dump', '~> 3.2'

# For signing users up to Mailchimp
gem 'devise_campaignable', '~> 0.2', github: 'sorry-app/devise_campaignable'

# For inflecting in results
gem 'indefinite_article', '~> 0.2.4'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'spring-commands-rspec'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'binding_of_caller'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.1'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  
  gem 'better_errors'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'rails_layout'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'cucumber-rails', require: false
  gem 'capybara-screenshot'
  gem 'headless'
  gem 'capybara-webkit'
end

group :production do
  gem 'rails_12factor', '~> 0.0.3'
end
