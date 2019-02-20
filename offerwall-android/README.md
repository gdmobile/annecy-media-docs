# Annecy Media Offerwall (Android)

Use our [API docs](https://admin.annecy.media/docs) for an awesome integration experience!

## Sample

Check out our [Sample Project](https://github.com/gdmobile/annecy-media-docs/tree/master/offerwall-android/sample)!

## Example

You can get your custom web offerwall URL [here](https://admin.annecy.media/offerwall). Create a WebView and make sure that clicked offers will open in default browser!

``` java
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;
import java.util.Locale;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        final Activity activity = this;

        // Set your publisher token and user ID
        String TOKEN = "6ce0bbf0-2dc8-4d7c-a497-e93105188ba1";
        String USER_ID = "foo";

        // Get user settings
        String language = Locale.getDefault().getLanguage();
        String country = "DE";
        String googleAdvertisingID = "bar";

        // Create an Annecy WebWiew
        WebView mAnnecyWebView = new WebView(this);
        mAnnecyWebView.getSettings().setJavaScriptEnabled(true);
        mAnnecyWebView.setWebViewClient(new WebViewClient() {
            @SuppressWarnings("deprecation")
            @Override
            public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
                Toast.makeText(activity, description, Toast.LENGTH_SHORT).show();
            }

            @TargetApi(android.os.Build.VERSION_CODES.M)
            @Override
            public void onReceivedError(WebView view, WebResourceRequest req, WebResourceError rerr) {
                onReceivedError(view, rerr.getErrorCode(), rerr.getDescription().toString(), req.getUrl().toString());
            }

            public boolean shouldOverrideUrlLoading(WebView view, String url) {

                // Open offers in default browser
                if (url != null && url.startsWith("https://")) {
                    view.getContext().startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));

                    return true;
                } else {
                    return false;
                }
            }
        });

        // Support mixed images
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            mAnnecyWebView.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_COMPATIBILITY_MODE);
        }

        mAnnecyWebView.loadUrl("https://offerwall.annecy.media?country=" + country + "&language=" + language + "&idfa_gaid=" + googleAdvertisingID + "&token=" + TOKEN + "&user_id=" + USER_ID + "&platform=android");
        setContentView(mAnnecyWebView);
    }
}
```
