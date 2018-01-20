# Annecy Rewards (PHP)

Use our [API docs](https://admin.annecy.media/docs) for an awesome integration experience!

## Sample

Check out our [Sample Project](https://github.com/gdmobile/annecy-media-api/tree/master/rewards-php/sample/reward.php)!

## PHP Example

As soon as an advertiser triggered an interaction, Annecy instantly calls your **reward URL**. If your backend responses a 200 HTTP status, then the interaction state will be set to `Rewarded`. If your backend is down, then the interaction state will be set to `Failed` and Annecy tries to send the interaction over and over again. Select your publisher [here](https://admin.annecy.media/publishers) to set your `Secret`, `Reward URL` and `Algorithm`.

Annecy calls your reward URL like this:

```
https://api.your-company.com/reward?user_id=foo&credits=100&campaign_title=bar&signature=218b99be4bb589a6a200e94ac26afee620fe83d6
```

Then we extract all query params:

``` php
$query_string = parse_url($url, PHP_URL_QUERY);
parse_str($query_string, $query_params);
```

`$query_params` will look like this:

``` php
[
    "user_id" => "foo",
    "credits" => "100",
    "campaign_title" => "bar",
    "signature" => "218b99be4bb589a6a200e94ac26afee620fe83d6"
]
```

Then we have to sort the `$query_params` by key, remove the signature param, and build an HTTP query:

``` php
ksort($query_params);
$signature = $query_params["signature"];
unset($query_params["signature"]);
$query_string = http_build_query($query_params);
```

`$query_string` will now look like this:

``` php
"campaign_title=bar&credits=100&user_id=foo"
```

Then we have to hash the `$query_string` with your secret. If the result is the same like signature, then it's a valid reward:

``` php
$hashed_signature = hash_hmac("sha1", $query_string, "YourSecret");
if ($hashed_signature == $signature) {
    header("HTTP/1.1 200 OK");
} else {
    header('HTTP/1.1 403 Forbidden', true, 403);
}
```
