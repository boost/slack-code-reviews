CODE REVIEWS
============

[Slack app](https://api.slack.com/apps/ANM8CQ1DG/general)
---------------------------------------------------------

- It currently contains only a `slash command` which is `/cr`
- Install the app in your slack workspace and type `/cr --help` to see the features

Contributing
------------

- Set up the project with the "Development" section
- Ask to be a collaborator on the [Slack application](https://api.slack.com/apps/ANM8CQ1DG/general)
- Create a `/<yourname>cr` slash command. Don't forget to tick:
  "Escape channels, users, and links sent to your app"
- Start `ngrok http 3000` in a terminal
- Copy the hostname into your `application.yml` "TUNNEL_HOST"
- Ask the values to customize the rest of the `application.yml` 

Development
-----------

```bash
# Install and launch an http tunnel to your computer
brew cask install ngrok
ngrok http 3000
# Set up the rails app in another terminal
bundle install
cp config/application.example.yml config/application.yml
# customize the value of the slack signing secret (See section "Slack app")
bin/rails db:setup
bin/rails rails server
```

Edit `config/application.yml` and update `TUNNEL_HOST '<id>.ngrok.io'` in the `default` block.

"Create New Command" on [Slash Commands](https://api.slack.com/apps/ANM8CQ1DG/slash-commands) with:

- Command: `/<your name>cr`, i.e. "/davecr"
- Request URL: `https://<id>.ngrok.io/slack-api/slash-command`
- Short Description: "Your name"
- Check "Escape channels, users, and links sent to your app"


Deployment
----------

Github Actions will automatically build and deploy the application once you create a new tag. 

The secrets are here https://github.com/boost/slack-code-reviews/settings/secrets/new.

The keys are kept in 1password. 

drone access keys and Slack Code Review Public Private Deploy Key
