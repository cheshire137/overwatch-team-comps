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

You will need Ruby and Rubygems installed.

```bash
bundle install
bundle exec rails s
```

Visit [localhost:3000](http://localhost:3000).
