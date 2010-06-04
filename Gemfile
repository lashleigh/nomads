#include at least one source and the rails gem
source :gemcutter
gem 'rails', '~> 2.3.5', :require => nil
gem 'sqlite3-ruby', :require => 'sqlite3'

# Devise 1.0.2 is not a valid gem plugin for Rails, so use git until 1.0.3
# gem 'devise', :git => 'git://github.com/plataformatec/devise.git', :ref => 'v1.0'
gem 'flickraw', :git => 'git://github.com/hanklords/flickraw.git', :ref => '0.8.2'

group :plugins do
  # gems that should be loaded in all environments, but depend on Rails to load
  gem 'newrelic_rpm'
end

group :development do
  # bundler requires these gems in development
  gem 'rails-footnotes'
end

group :test do
  # bundler requires these gems while running tests
  gem 'rspec'
end
