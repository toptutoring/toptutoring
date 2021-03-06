# Top Tutoring

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % ./bin/setup

It assumes you have a machine equipped with Ruby, Postgres, etc. If not, set up
your machine with [this script].

[this script]: https://github.com/thoughtbot/laptop

After setting up, you can run the application using [Heroku Local]:

    % heroku local

[Heroku Local]: https://devcenter.heroku.com/articles/heroku-local

[Check out our wiki](https://github.com/plexmate/toptutoring/wiki) for more detailed instructions and explanations.

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)

## Deploying

If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:

    $ ./bin/deploy staging
    $ ./bin/deploy production

## Live Styleguide Through Storybook

We will be using storybook as our live styleguide. This means you can
use storybook to see which components we currently using on our site as
well as develop new components and see your changes in storybook as you
develop.

To run storybook make sure your assets are compiled through rails and run
    % npm run storybook

## Dig Deeper

[Check out our wiki](https://github.com/plexmate/toptutoring/wiki) for a more detailed installation guide as well as in depth explanation of our code and process.
