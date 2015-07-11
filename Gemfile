source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.1'
ruby '2.2.1'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Bootstrap styles
#gem 'bootstrap-sass', '~> 3.3.5'

# Font Awesome
gem 'font-awesome-rails', '~> 4.3.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby, group: :production

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Supplement to Turbolinks so the template works
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Integration with heroku
#gem 'rails_12factor', group: :production

# Work with spreadsheets
gem 'roo', '~> 2.0.0'

# Allow haml files
gem 'haml'

# PDF Generation
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary', group: :development
#gem 'wkhtmltopdf-heroku', group: :production

# PDF Combination
gem 'combine_pdf'

# PDF Filling
gem 'pdf-forms'
#gem 'pdf_ravager', '~> 0.2.2'

# randomize date (and other things)
gem 'ish', '~> 0.0.1'

# User Accounts
gem 'devise', '~> 3.4'

# Development emails
gem 'letter_opener', group: :development

# Deployment Details (Use Capistrano for deployment)
group :development do
    gem 'capistrano',         require: false
    gem 'capistrano-rvm',     require: false
    gem 'capistrano-rails',   require: false
    gem 'capistrano-rails-console', require:false
    gem 'capistrano-bundler', require: false
    gem 'capistrano3-puma',   require: false
end

# a better server
gem 'puma'
