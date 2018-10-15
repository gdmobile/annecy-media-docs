const crypto = require('crypto');

// TODO:
// - Set your secret!
// - Set the name of your custom signature query!
// - Set signature hash algorythm!
const SECRET = 'HzH7DGjcHjvGcNmCqtBy';
const SIGNATURE_QUERY_NAME = 'signature';
const HASH_ALGORITHM = 'sha1';

// The params are decoded with PHP.
// That's why you have to use this special encoder.
//
// Source: https://github.com/kvz/locutus/blob/master/src/php/url/urlencode.js
function urlencode(str) {
    return encodeURIComponent(str)
        .replace(/!/g, '%21')
        .replace(/'/g, '%27')
        .replace(/\(/g, '%28')
        .replace(/\)/g, '%29')
        .replace(/\*/g, '%2A')
        .replace(/%20/g, '+');
}

// Get and extract your query params.
//
// If you're using ExpressJS, use `req.params`.
// Source: http://expressjs.com/de/api.html#req
const queryParams = {
    credits: '100',
    campaign_title: 'Awesome Offer',
    user_id: 'foo',
    click_id: 'bar',
    signature: 'a7b7c51e92b228e38399196cc11e0d57b467f006'
};

const sortedQueryParams = [];

// Sort and encode the query params.
Object.keys(queryParams).forEach((queryParam) => {
    if (queryParam !== SIGNATURE_QUERY_NAME) {
        sortedQueryParams.push(`${ urlencode(queryParam) }=${ urlencode(queryParams[queryParam]) }`);
    }
});

// Build an HTTP query string.
const queryString = sortedQueryParams.join('&');
const hmac = crypto.createHmac(HASH_ALGORITHM, SECRET);
const signature = hmac.update(queryString).digest('hex');

// Check if the hashed signature is euqual to query signature.
if (signature === queryParams[SIGNATURE_QUERY_NAME]) {
    // Set response with 200 header.
} else {
    // Set response with 403 header.
}
