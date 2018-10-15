# Annecy Media Rewards (Node.js)

Use our [API docs](https://admin.annecy.media/docs) for an awesome integration experience!

## Sample

Check out our [Sample Project](https://github.com/gdmobile/annecy-media-docs/tree/master/rewards-node/sample/reward.js)!

## Description

As soon as an advertiser triggered an interaction, Annecy instantly calls your **reward URL**. If your backend responses a 200 HTTP status, then the interaction state will be set to `Rewarded`. If your backend is down, then the interaction state will be set to `Failed` and Annecy tries to send the interaction over and over again. Select your publisher [here](https://admin.annecy.media/publishers) to set your `Secret`, `Reward URL` and `Algorithm`.
