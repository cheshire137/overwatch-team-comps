# Overwatch Team Comps

Mystery project with Rob and Zion.

## How to Develop

You will need Ruby, Rubygems, and npm installed.

```bash
bundle install
npm install
bin/rake db:migrate db:seed
bundle exec rails s
```

Visit [localhost:3000](http://localhost:3000).

To add a new JavaScript package: `npm install WHATEVER_PACKAGE --save`

## How to Test

```bash
bundle install
npm install
npm run style # to run the JavaScript style checker
RAILS_ENV=test bin/rake db:migrate
rake test # to run Rails tests
```

## How to Deploy to Heroku

WIP

```bash
heroku buildpacks:add https://github.com/heroku/heroku-buildpack-nodejs.git
heroku buildpacks:add https://github.com/heroku/heroku-buildpack-ruby.git
```
