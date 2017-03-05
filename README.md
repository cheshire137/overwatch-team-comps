# Overwatch Team Comps

Mystery project with Rob and Zion.

## How to Develop

You will need Ruby and Rubygems installed.

```bash
bundle install
bin/rake db:migrate db:seed
bundle exec rails s
```

Visit [localhost:3000](http://localhost:3000).

## How to Test

```bash
bundle install
RAILS_ENV=test bin/rake db:migrate
rake test
```
