# CoffeeTracker

This is a simple app to track how much coffee we have on hand for any given day.
The goal is to notice trends over time and make sure we order the right amount
of coffee every two weeks.

The expected interaction is to come into the office each morning and weigh the
coffee containers. We have bags of coffee, cannisters with coffee in them, and a
hopper on the grinder. Each container is setup in the system with it's empty
weight. When making a measurement, just indicate what container you're weighing
and record the total weight. The app will subtract out the container weight when
reporting totals.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
