# Overwatch Team Comps

A web app that allows Overwatch players to plan out their team composition
for every point of every map on both offense and defense. Players should be
able to save their team comps as well as be able to easily share their team
comps.

Feature planning is done on [our Trello board](https://trello.com/b/STeIZ1td/project-overwatch-team-comp-organizer).

If interested, see also [our requirements document](https://trello.com/c/GCIwE5We/5-end-user-requirements-version-1) that contains a high-level description of all the end-user features of this product.

![Sample Mockup of Team Comp Form 01](https://raw.githubusercontent.com/cheshire137/overwatch-team-comps/master/readme%20screens%20-%20team%20comp%20form%2001.png)

![Sample Mockup of Team Comp Form 02](https://raw.githubusercontent.com/cheshire137/overwatch-team-comps/master/readme%20screens%20-%20team%20comp%20form%2002.png)

![Sample Mockup of Hero Pool Page](https://raw.githubusercontent.com/cheshire137/overwatch-team-comps/master/readme%20screens%20-%20hero%20pool.png)

![Sample Mockup of Hero Select Drop Down Menu](https://raw.githubusercontent.com/cheshire137/overwatch-team-comps/master/readme%20screens%20-%20hero%20select%20drop%20down.png)

## App Structure

- Ruby on Rails web app using [React](https://facebook.github.io/react/) for a speedy,
  single-page front end
    - This means most views will be implemented in
      [JSX](https://facebook.github.io/react/docs/jsx-in-depth.html) in
      app/assets/javascripts/components/ instead of ERB in app/views/.
- Rails endpoints will provide a JSON REST API for the front end
- PostgreSQL database for convenient deployment to Heroku
- Potential integration with OAuth providers such as Discord for authentication
  built on top of [Devise](https://github.com/plataformatec/devise)

## How to Develop

You will need Ruby, Rubygems, PostgreSQL, and npm installed.

```bash
bundle install
npm install
bin/rake db:setup
bundle exec rails s
```

Visit [localhost:3000](http://localhost:3000).

You can view the style guide at
[localhost:3000/pages/styleguide](http://localhost:3000/pages/styleguide).

To add a new JavaScript package: `npm install WHATEVER_PACKAGE --save`

### OAuth in Local Development

To test OAuth signin locally, you will need to
[create a Battle.net API app](https://dev.battle.net),
`cp dotenv.sample .env`, and
copy your app key and secret into the .env file. You will also need to
use a service like [ngrok](https://ngrok.com/) to have a public URL
that will hit your local server. Start ngrok via `ngrok http 3000`;
look at the https URL it spits out. In your Battle.net app, set
`https://your-ngrok-id-here.ngrok.io/users/auth/bnet/callback` as
the "Register Callback URL" value. Update .env so that `BNET_APP_HOST`
is set to the same `your-ngrok-id-here.ngrok.io` as ngrok spit out and you used
in the Battle.net app; omit the `https://` in .env. Start the Rails server
via `bundle exec rails s`. Now you should be able to go to
`https://your-ngrok-id-here.ngrok.io/` and click the Battle.net link.

### Installing PostgreSQL on macOS

There are multiple ways to install PostgreSQL, but the recommended way is
through homebrew:

```shell
brew install postgresql
```

To manage your installation of PostgreSQL, one way is to use `brew/services`:

```shell
brew install homebrew/services
brew services start postgresql
```

At anytime you can stop the PostgreSQL service:

```shell
brew services stop postgresql
```

## How to Test

After running through the development setup above, then:

```bash
npm test # to run the JavaScript style checker and JavaScript tests
bundle exec rspec # to run Rails tests
```

You can run just the style checker via `npm run style`. You can run just
the JavaScript tests via `npm run unit-test`.

Snapshots are used in JavaScript tests --
see [`spec/javascript/components/__snapshots__/`](spec/javascript/components/__snapshots__/) --
to test that a React component is rendered the same way consistently based
on the props it's given. If you update a component, a test may fail
because the snapshot is now different from what is rendered. Manually
compare the two and if the change is expected, update the now out-of-date
snapshot with `npm run unit-test -- -u`.

See also these links about the JavaScript tests:

- [Shallow rendering with Enzyme](http://airbnb.io/enzyme/docs/api/shallow.html)
- [Jest matchers](https://facebook.github.io/jest/docs/expect.html#content)
- [ESLint rules](http://eslint.org/docs/rules/)

## How to Deploy to Heroku

Create an [app on Heroku](https://dashboard.heroku.com/apps).

Create a [Battle.net app](https://dev.battle.net) and set its "Register Callback URL" to
`https://your-heroku-app.herokuapp.com/users/auth/bnet/callback`.

```bash
heroku git:remote -a your-heroku-app
heroku buildpacks:add https://github.com/heroku/heroku-buildpack-nodejs.git
heroku buildpacks:add https://github.com/heroku/heroku-buildpack-ruby.git
heroku config:set BNET_APP_ID=your_app_id_here
heroku config:set BNET_APP_SECRET=your_app_secret_here
heroku config:set BNET_APP_HOST=your-heroku-app.herokuapp.com
git push heroku master
heroku run rake db:migrate
heroku run rake db:seed
heroku open
```
