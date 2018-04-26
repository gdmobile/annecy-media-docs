<?php

// TODO:
// - Set the name of your custom signature query!
// - Set signature hash algorythm!
// - Set your secret!
$SIGNATURE_QUERY_NAME = "signature";
$HASH_ALGORITHM = "sha1";
$SECRET = "HzH7DGjcHjvGcNmCqtBy";

// Get reward URL.
$url = (isset($_SERVER["HTTPS"]) ? "https" : "http") . "://" . $_SERVER["HTTP_HOST"] . $_SERVER["REQUEST_URI"];

// Extract all query params.
$query_string = parse_url($url, PHP_URL_QUERY);
parse_str($query_string, $query_params);

// Sort the query params by key.
ksort($query_params);

// Store the signature and remove it from query params.
$signature = $query_params[$SIGNATURE_QUERY_NAME];
unset($query_params[$SIGNATURE_QUERY_NAME]);

// Build an HTTP query string.
$query_string = http_build_query($query_params);

// Build an hashed signature.
$hashed_signature = hash_hmac($HASH_ALGORITHM, $query_string, $SECRET);

// Check if the hashed signature is euqual to query signature.
if ($hashed_signature == $signature) {

    // This request is valid.
    // Tell the user that she/he got credits!
    // Store click ID and campaign title to validate with Annecy later.
	$click_id = $query_params["click_id"];
	$campaign_title = $query_params["campaign_title"];

    header("HTTP/1.1 200 OK");
} else {
    header("HTTP/1.1 403 Forbidden", true, 403);
}

?>
