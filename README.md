# Annecy Media API

Use our [API docs](https://admin.annecy.media/docs) for an awesome integration experience!

## Get Offers

Returns a list of all available and active offers for your Publisher. The response contains static offers **and** lazy offers. The lazy offers have two additional fields (`lazy<boolean>` and `lazy_id<id>`). If there are any lazy offers in the response, then you have to call the URL we've sent you in `lazy_calls` response.

#### Parameters

| Parameter      | Type     | Notes |
| -------------- | -------- | ----- |
| country        | `string` | Country (specified in ISO 3166, two letter countries) |
| locale         | `string` | Locale for selecting the translations (ISO 639-1, two letter locales) |
| platform       | `string` | Platform of the requesting device (`ios`, `android`) |
| advertiser\_id | `string` | ID for Advertisers (IDFA, GAID) |
| ip             | `string` | IP address of the requesting device |
| user\_id       | `string` | User ID of your user |


#### Request

```

GET https://api.annecy.media/offers?country={country}&locale={locale}&platform={platform}&advertiser_id={advertiser_id}&ip={ip}&user_id={user_id}

Headers
    Authorization: Bearer 7478AF4B-649F-4843-AC3E-84CE7CC0739D
    API-Version: 1.0

```

#### Response

##### 200 (application/json)

```json

{
    "data": {
        "offers": [
            {
                "type": "offer",
                "campaign_uuid": "123ae848-c13e-4bd3-a66a-506d93a8cb0f",
                "title": "Non Lazy Offer",
                "text": "Install and open the app!",
                "cta_title": "This is how it works",
                "cta_text": "1.) Install the app\n2.) Open the app",
                "credits": 300,
                "cost_type": "cpi",
                "tracking_url": "https:\/\/api.annecy.media\/redirect?redirect=https%3A\/\/example.com",
                "attributes": {
                    "border": "red",
                    "hint": "Deal of the day"
                }
            }, {
                "type": "offer",
                "campaign_uuid": "456ae848-c13e-4bd3-a66a-506d93a8cb0f",
                "lazy": true,
                "lazy_id": "43818c8d0ddb8a3c79e73aa6793f1738",
                "title": "Lazy Offer",
                "text": "Install and open the app!",
                "cta_title": "This is how it works",
                "cta_text": "1.) Install the app\n2.) Open the app",
                "credits": 200,
                "cost_type": "cpi",
                "tracking_url": "https:\/\/api.annecy.media\/redirect?redirect=REPLACE_TRACKING_URL&hash=GBlR3Q06bY9pWROCRs3ClRyKrwoLzEXJ"
            }
        ],
        "request_id": "EWA1xGV",
        "lazy_calls": [
            "https:\/\/api.annecy.media\/offers\/lazy?hash=ZAqzoM0VYjL5QwCWC6CZ0yGlEO4R7wnx&country=DE&locale=de&platform=ios&user_id=b38fc80decac0523c2e690ea6311aa2f&advertiser_id=8f69a791-4b56-465e-a94e-ac3896a06b13&lazy_ids%5B0%5D=f29d5cc22cbb9eef3e9e531c6c5001c1"
        ]
    }
}

```

##### 400 (application/json)

```json

{
    "status": 1000,
    "message": "Oops, an error occurred!"
}

```


##### 403 (application/json)

```json

{
    "data": null,
    "status": null,
    "message": "Full authentication is required to access this resource."
}

```

##### 500 (text/plain)

## Get Lazy Offers

You can find lazy offer URLs inside the `GET /offers` response. They have to be called separately, to get your specific tracking URL. It's possible that not all lazy offers you've got from `GET /offers` are available. That's why you should hide them, until you've got the real tracking URL.

##### Parameters

| Parameter      | Type     | Notes |
| -------------- | -------- | ----- |
| hash           | `string` | Signature hash |
| country        | `string` | Country (specified in ISO 3166, two letter countries) |
| locale         | `string` | Locale for selecting the translations (ISO 639-1, two letter locales) |
| platform       | `string` | Platform of the requesting device (`ios`, `android`) |
| advertiser\_id | `string` | ID for Advertisers (IDFA, GAID) |
| ip             | `string` | IP address of the requesting device |
| user\_id       | `string` | User ID of your user |
| lazy\_ids[]    | `string` | List of IDs from the lazy offers

#### Request

```

GET https://api.annecy.media/offers/lazy?hash={hash}&country={country}&locale={locale}&platform={platform}&advertiser_id={advertiser_id}&ip={ip}&user_id={user_id}&lazy_ids[]={lazy_id_1}&lazy_ids[]={lazy_id_2}

Headers
    Authorization: Bearer 7478AF4B-649F-4843-AC3E-84CE7CC0739D
    API-Version: 1.0

```

#### Response

##### 200 (application/json)

```json

{
    "data": {
        "lazy_offers": [
            {
                "lazy_id": "f29d5cc22cbb9eef3e9e531c6c5001c1",
                "fields": [
                    {
                        "field": "tracking_url",
                        "search": "REPLACE_TRACKING_URL",
                        "replace": "https%3A%2F%2Fadvertiser.com%2Foffer"
                    }
                ]
            }
        ]
    }
}

```

##### 400 (application/json)

```json

{
    "status": 1000,
    "message": "Oops, an error occurred!"
}

```

##### 403 (application/json)

```json

{
    "data": null,
    "status": null,
    "message": "Full authentication is required to access this resource."
}

```

##### 500 (text/plain)

## Send Views

Views are used to calculate the performance for your offers. In every `GET /offers` request you receive a `request_id`. We need this id back in the body. You can only add one view per offer and `request_id`.

#### Request

```

POST https://api.annecy.media/views

Headers
    Authorization: Bearer 7478AF4B-649F-4843-AC3E-84CE7CC0739D
    API-Version: 1.0

Body
    {
        "params": {
            "locale": "de",
            "country": "DE",
            "platform": "ios",
            "user_id": "b38fc80decac0523c2e690ea6311aa2f",
            "advertiser_id": "E5BCF23E-BBEB-41CF-9971-64DC74F6E881"
        },
        "offers": [
            {
                "uuid": "123ae848-c13e-4bd3-a66a-506d93a8cb0f",
                "view_time": "1505215643"
            }, {
                "uuid": "456ae848-c13e-4bd3-a66a-506d93a8cb0f",
                "view_time": "1505215645"
            }
        ],
        "request_id": "EWA1xGV"
    }

```

#### Response

##### 200 (application/json)

```json

[]

```

##### 400 (application/json)

```json

{
    "status": 1000,
    "message": "Oops, an error occurred!"
}

```

##### 403 (application/json)

```json

{
    "data": null,
    "status": null,
    "message": "Full authentication is required to access this resource."
}

```

##### 500 (text/plain)
