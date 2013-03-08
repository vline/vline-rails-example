# vLineRails Example

The vLineRails Example shows you how to create a Rails app that can be used with the low level vLine API and also
used to launch a version of the vLine app that uses the users you provide.

## Before you begin

1. Sign up for a [vLine developer account] (https://vline.com/developer).
1. Sign up for [forward](https://forwardhq.com/) and install the gem: `gem install forward`
1. Install ruby version 1.9.3 or newer
1. Clone this repository.
1. Optional: [Install rvm](https://rvm.io/rvm/install/)

## Create your vLine app

Create an app in the vLine developer console.

## Create your Rails app (Rails 3.x)


1. Change into the directory where you cloned this repository.

1. Install all dependencies:

        bundle install

1. Create an app directory and change into it:

        mkdir ../vline
        cd ../vline

    The following instructions walk you through creating the Rails app from scratch. If you'd rather use the
pre-generated one, you can skip to the "Configure your app" step.

1. Create the new app:

        rails new vline-demo-app -m https://raw.github.com/RailsApps/rails-composer/master/composer.rb -T

1. You will get several prompts. Choose the following:
    * `4) rails-3-bootstrap-devise-cancan`
    * `1) WEBrick (default)`
    * `1) Same as development`
    * `1) ERB`

1. If you get any error messages during this process, take a look at [this page](http://railsapps.github.com/rails-error-you-have-already-activated.html).

1. Change into the app directory:

        cd vline-demo-app

1. The email and password for the admin account is in `config/application.yml`. It is probably `user@example.com` and `changeme`.

1. Create some extra users by adding the following to the `db/seeds.rb` file:

        for i in 2..5
            user = User.find_or_create_by_email :name => "User #{i}", :email => "user#{i}@example.com", :password => 'changeme', :password_confirmation => 'changeme'
            puts 'user: ' << user.name
            user.add_role :user
        end


### Install vLineRails Plugin in your application

1. Find your app in the vLine Developer console and make note of the `App Id` and `App Secret`.

1. Use the values from the last step to generate the vLine provider by running the following command:

        rails generate vline_provider --app-id=Your-App-Id --provider-secret=Your-App-Secret

    Make note of the `Client Id` and `Client Secret` output by the command.

1. Check your `config.ru` file and verify that it has:

        require 'rack/jsonp'
        use Rack::JSONP

### Add presence to your Rails app

1. At the top of `app/views/home/index.html.erb`, add the following, which includes the vline JavaScript:

        <% content_for :head do %>
          <script src="https://static.vline.com/vline.js" type="text/javascript"></script>
        <% end %>

1. In the same file, replace:

        <p>User: <%=link_to user.name, user %></p>

    with

        <div>
          User: <%= vline_launch user.name, user %>, Presence: <span id="<%= user.id %>">offline</span>
        </div>

1. In the same file, add the following JavaScript at the bottom of the file:

        <script type="text/javascript">
            var loginToken = "<%= Vline.create_login_token(current_user.id) %>";
            var appId = "<%= Vline.app_id %>";
            var authId = "<%= Vline.provider_id %>";
            var profile = {"displayName" : "<%= current_user.name %>"};

            var people = [
                <% @users.each do |user| %>
                "<%= user.id %>",
                <% end %>
            ];

            var client = vline.client.create(appId);

            client.on('login', function(e) {
                var session = e.target;

                for (var i=0; i < people.length; i++) {
                    session.getPerson(people[i])
                            .done(function(person) {
                                var updatePresence = function(e) {
                                    var person = e.target;
                                    var elem = document.getElementById(person.getShortId());
                                    elem.innerHTML = person.getPresenceState();
                                };

                                updatePresence({target: person});
                                person.on('change:online', updatePresence);
                            });
                }
            });

            client.login(authId, profile, loginToken);
        </script>

1. In the home controller (`app/controllers/home_controller.rb`), force the user to login to see the page with:

        before_filter :authenticate_user!

    at the beginning of the class (`class HomeController < ApplicationController`)

    Also, add:

        require 'vline'

    to the top of the file.

## Configure your app

1. Prepare the database:

        rake db:migrate
        rake db:seed

1. Generate a secret token:

        rake secret

1. Add the generated token to `config/initializers/secret_token.rb`.

1. Start forward by running the following command in your app directory:

        forward 3000

    Make a note of the URL that it prints so that you can use it in the next steps.

1. Go the configuration page for your app in the vLine developer console.

1. You'll notice there are default URLs set for images used by the app. You can leave these as-is or change them to
custom images for your app.

1. Select `Custom OAuth` in the `Authorization` dropdown:
    * Add the `Client Id` and `Client Secret` from the `rails generate` command you previously ran.
    * Set the `Provider URL` to : `https://your-forward-url/_vline/api/v1/`
    * Set the `OAuth URL` to: `https://your-forward-url/_vline/api/v1/oauth/`

## Run your app

1. Run the rails server in your app directory:

        rails server

1. Go to [http://localhost:3000](http://localhost:3000) in your browser.
1. Log in as `user@example.com`.
1. Open up a Chrome incognito window.
1. Log in as `user2@example.com`.
1. You should see both "First User" and "User 2" online.
