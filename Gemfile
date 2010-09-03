source 'http://rubygems.org'

gem 'rails', '3.0.0.rc'

gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'mysql', :group => :development

# Development
# ===========
group :development do
  gem 'rails3-generators'
  gem 'rspec-rails', ">= 2.0.0.beta.19"
  # Haml generators
  gem 'hpricot'
  gem 'ruby_parser'
end

# Test
# ====
group :test do
  gem 'rspec'
  gem 'rspec-rails', ">= 2.0.0.beta.19"
  gem 'factory_girl_rails'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'capybara'
  gem 'shoulda'
  gem 'webrat'
end

# Standard helpers
# ================
gem 'haml'
gem 'compass', '>= 0.10.4'
gem 'fancy-buttons'

gem 'simple-navigation'

gem 'formtastic', :git => 'git://github.com/justinfrench/formtastic.git', :branch => 'rails3'
gem 'will_paginate', :git => 'http://github.com/huerlisi/will_paginate.git', :branch => 'rails3'
gem 'has_scope'
gem 'inherited_resources'
gem 'i18n_rails_helpers', '>= 0.8.0'

# Mailyt
# ======
# Attachments
gem 'paperclip'

# Gems only for ruby 1.8
platforms :ruby_18 do
  # IMAP fetcher
  gem 'system_timer'
end

# Authentication
gem 'devise', '>= 1.1'
