CODE REVIEWS
============

[Slack app](https://api.slack.com/apps/ANM8CQ1DG/general)
---------------------------------------------------------

- It currently contains only a `slash command` which is `/cr`
- Install the app in your slack workspace and type `/cr --help` to see the features

Development
-----------

```
bundle install
cp config/application.example.yml config/application.yml
# customize the value of the slack signing secret (See section "Slack app")
rails s # to start the server
rails "codereview:run[-h]" # to use the command line instead of slack directly
```
