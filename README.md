CODE REVIEWS
============

[Slack app](https://api.slack.com/apps/ANM8CQ1DG/general)
---------------------------------------------------------

- It currently contains only a `slash command` which is `/cr`
- Install the app in your slack workspace and type `/cr --help` to see the features

Development
-----------

```bash
bundle install
cp config/application.example.yml config/application.yml
# customize the value of the slack signing secret (See section "Slack app")
bundle exec rake db:setup
bundle exec rails server
brew cask install ngrok
ngrok http 3000
```

Edit `config/environments/development.rb` and add `config.hosts << '<id>.ngrok.io'` in the `configure` block.

"Create New Command" on [Slash Commands](https://api.slack.com/apps/ANM8CQ1DG/slash-commands) with:

* Command: `/<your name>cr`, i.e. "/davecr"
* Request URL: `https://<id>.ngrok.io/slack-api/slash-command`
* Short Description: "Your name"
* Check "Escape channels, users, and links sent to your app"

```
bin/codectl --help # to use the command line instead of slack directly
```

Deployment
----------

Build the docker and push it:
```bash
$(aws ecr get-login --no-include-email --region ap-southeast-2 | sed 's|https://||')
docker build -t 581987047035.dkr.ecr.ap-southeast-2.amazonaws.com/slack-code-reviews:$(git rev-parse --short=7 HEAD) .
docker push     581987047035.dkr.ecr.ap-southeast-2.amazonaws.com/slack-code-reviews:$(git rev-parse --short=7 HEAD)
```

Deploy to the Boost kubernetes cluster:
```bash
cd ~/Dev/boost-kubernetes
git checkout -b 'upgrade-slack-code-reviews'
# update the docker image with the new tag in: projects/boost/slack-code-reviews/prod/app.yaml
git add --patch projects/boost/slack-code-reviews/prod/app.yaml
git push --set-upstream origin $(git_current_branch)
# get it code reviewed and merged to master
# Flux will do the deployment for you
```

Notify airbrake of the deployment:
```bash
bundle exec rake airbrake:deploy \
    ENVIRONMENT=production \
    REVISION=$(git rev-parse HEAD)
    REPOSITORY=$(git remote get-url origin)
```
