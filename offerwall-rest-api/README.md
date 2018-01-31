# Annecy Media Offerwall (REST API)

Use our [API docs](https://admin.annecy.media/docs) for an awesome integration experience!

* [Checklist](#checklist)
* [API](#api)
    * [Offers](#get-offers)
    * [Lazy Offers](#get-lazy-offers)
    * [Views](#send-views)

## Checklist

* You have an Annecy Media account and token
    * [Register](https://admin.annecy.media/getting-started) or [Login](https://admin.annecy.media/login)
    * Create a **Token** in your [Publisher Settings](https://admin.annecy.media/publishers)

## API

You have to set an `Authorization` and `API-Version` header to all requests. Replace `<token>` with your publisher token from your [Publisher Settings](https://admin.annecy.media/publishers). Do not hash the token!

| Header        | Value            |
| ------------- | ---------------- |
| Authorization | `Bearer <token>` |
| API-Version   | `1.0`            |

### Get Offers

```
GET https://api.annecy.media/offers?country=<country>&locale=<locale>&platform=<platform>&advertiser_id=<advertiser_id>&ip=<ip>&user_id=<user_id>
```

Returns an `Array` of all active offers. The response contains static offers **and** lazy offers. Lazy offers have the additional fields `lazy<Boolean>` and `lazy_id<String>`.  Lazy offers doesn't have a valid tracking URL! You have to replace them with `fields` from `GET /offers/lazy`.

#### Parameters

| Parameter      | Type     | Notes |
| -------------- | -------- | ----- |
| country        | `String` | Country - ISO 3166 (`US`, `GB`, `DE`) |
| locale         | `String` | Language - ISO 639-1 (`en`, `es`, `de`) |
| platform       | `String` | Platform of the requesting device (`ios`, `android`) |
| advertiser\_id | `String` | ID for Advertisers (IDFA, GAID) |
| ip             | `String` | IP address of the requesting device |
| user\_id       | `String` | User ID of your user |

#### Response

200 (application/json)

``` json
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

400 (application/json)

``` json
{
    "status": 1000,
    "message": "Oops, an error occurred!"
}
```


403 (application/json)

``` json
{
    "data": null,
    "status": null,
    "message": "Full authentication is required to access this resource."
}
```

500 (text/plain)

```

```

### Get Lazy Offers

```
GET https://api.annecy.media/offers/lazy?hash=<hash>&country=<country>&locale=<locale>&platform=<platform>&advertiser_id=<advertiser_id>&ip=<ip>&user_id=<user_id>&lazy_ids[]=<lazy_id_1>&lazy_ids[]=<lazy_id_2>
```

Returns an `Array` of all active lazy offers. It is possible that not all lazy offers you've got from `GET /offers` are available. That's why you should hide them, until you've got the real tracking URL. As soon as you have the lazy offer, replace all placeholder `field`s in the offer. Search for the `search` value and replace it with the `replace` value.

Node.js Replace Example:

``` javascript
lazyOffers.forEach((lazyOffer) => {
    offers.forEach((offer) => {
        if (offer.lazy_id === lazyOffer.lazy_id) {
            lazyOffer.fields.forEach((field) => {
                offer[field.field] = offer[field.field].replace(field.search, field.replace);
            });

            offer.hidden = false;
        }
    });
});
```

#### Parameters

| Parameter      | Type     | Notes |
| -------------- | -------- | ----- |
| hash           | `String` | Signature hash |
| country        | `String` | Country - ISO 3166 (`US`, `GB`, `DE`) |
| locale         | `String` | Language - ISO 639-1 (`en`, `es`, `de`) |
| platform       | `String` | Platform of the requesting device (`ios`, `android`) |
| advertiser\_id | `String` | ID for Advertisers (IDFA, GAID) |
| ip             | `String` | IP address of the requesting device |
| user\_id       | `String` | User ID of your user |
| lazy\_ids[]    | `String` | List of IDs from the lazy offers

#### Response

200 (application/json)

``` json
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

400 (application/json)

``` json
{
    "status": 1000,
    "message": "Oops, an error occurred!"
}
```

403 (application/json)

``` json
{
    "data": null,
    "status": null,
    "message": "Full authentication is required to access this resource."
}
```

500 (text/plain)

```

```

### Send Views

```
POST https://api.annecy.media/views
```

#### Body

``` json
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

Views are used to calculate the performance for your offers. In every `GET /offers` request you'll get a `request_id`. Don't forget to set this ID to the body! You can only `POST` one view per offer and `request_id`.

200 (application/json)

``` json
[]
```

400 (application/json)

``` json
{
    "status": 1000,
    "message": "Oops, an error occurred!"
}
```

403 (application/json)

``` json
{
    "data": null,
    "status": null,
    "message": "Full authentication is required to access this resource."
}
```

500 (text/plain)

```

```
