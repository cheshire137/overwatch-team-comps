# Overwatch Team Comps

A web app that allows Overwatch players to plan out their team composition
for every point of every map on both offense and defense. Players should be
able to save their team comps as well as be able to easily share their team
comps.

Feature planning is done on [our Trello board](https://trello.com/b/STeIZ1td/project-overwatch-team-comp-organizer).

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

You will need Ruby, Rubygems and PostgreSQL installed.

```bash
bundle install
bin/rake db:setup
bundle exec rails s
```

Visit [localhost:3000](http://localhost:3000).

To test OAuth signin locally, you will need to
[create a Battle.net API app](https://dev.battle.net),
`cp dotenv.sample .env`, and
copy your app key and secret into the .env file. You will also need to
use a service like [ngrok](https://ngrok.com/) to have a public URL
that will hit your local server. Start ngrok via `ngrok http 3000`;
look at the https URL it spits out. In your Battle.net app, set
`https://your-ngrok-id-here.ngrok.io/users/auth/bnet/callback` as
the "Register Callback URL" value. Update .env so that `BNET_APP_HOST`
is set to the same `your-ngrok-id-here` as ngrok spit out and you used
in the Battle.net app; omit the https:// in .env. Start the Rails server
via `bundle exec rails s`.

### Installing PostgreSQL on mac os

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
bundle exec rspec
```
