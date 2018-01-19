# Annecy Rewards (PHP)

Use our [API docs](https://admin.annecy.media/docs) for an awesome integration experience!

## Demo

Check out our [Demo](https://github.com/gdmobile/annecy-media-api/tree/master/docs/rewards-php/demo/reward.php)!

## Example

Annecy calls the reward URL like this:

```
https://api.your-company.com/reward?user_id=foo&credits=100&campaign_title=bar&signature=218b99be4bb589a6a200e94ac26afee620fe83d6
```

Then we extract all query params:

```
$query_string = parse_url($url, PHP_URL_QUERY);
parse_str($query_string, $query_params);
```

$query_params will look like this:

```
[
    "user_id" => "foo",
    "credits" => "100",
    "campaign_title" => "bar",
    "signature" => "218b99be4bb589a6a200e94ac26afee620fe83d6"
]
```

Then we have to sort the $query_params by key, remove the signature param, and build an HTTP query:

```
ksort($query_params);
$signature = $query_params["signature"];
unset($query_params["signature"]);
$query_string = http_build_query($query_params);
```

$query_string will now look like this:

```
"campaign_title=bar&credits=100&user_id=foo"
```

Then we have to hash the $query_string with your secret. If the result is the same like signature, then it's a valid reward:

```
$hashed_signature = hash_hmac("sha1", $query_string, "YourSecret");
if ($hashed_signature == $signature) {
    // Success
}
```
