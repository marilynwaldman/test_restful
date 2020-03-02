# TestRestful





1.  `mix phx.new test_restful`

2. `mix phx.gen.html Accts User1 users1 name:string email:string phone_number:string`

Add the resource to your browser scope in lib/test_restful_web/router.ex:

    resources "/users", UserController


Remember to update your repository by running migrations:

    $ mix ecto.migrate
 
3. Install live view per the github:

https://github.com/phoenixframework/phoenix_live_view/blob/master/guides/introduction/installation.md



To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
