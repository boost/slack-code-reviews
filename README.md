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
rails server # to start the server
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
file=~/boost-kubernetes/apps/slack-code-reviews/prod/values.yaml
sed -e s/DEPLOY_TAG/$(git rev-parse --short=7 HEAD)/g "${file}" | kubectl apply -f -
```

Notify airbrake of the deployment:
```bash
bundle exec rake airbrake:deploy \
    ENVIRONMENT=production \
    REVISION=$(git rev-parse HEAD)
    REPOSITORY=$(git remote get-url origin)
```
