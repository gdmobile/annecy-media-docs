# Annecy Web Offerwall (iOS Objective-C)

Use our [API docs](https://admin.annecy.media/docs) for an awesome integration experience!

## Example

You can get your custom web offerwall URL [here](https://admin.annecy.media/offerwall). Create a WebView and make sure that clicked offers will open in Safari!

``` objective-c
#import "ViewController.h"
@import AdSupport;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set your publisher token and user ID
    NSString *TOKEN = @"6ce0bbf0-2dc8-4d7c-a497-e93105188ba1";
    NSString *USER_ID = @"foo";

    // Get user settings
    NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
    NSString *country = [locale objectForKey:NSLocaleCountryCode];
    NSString *language = [locale objectForKey:NSLocaleLanguageCode];
    NSString *idfa = [self idfa];

    // Create an Annecy WebWiew
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIWebView *annecyWebVew = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    NSURL *annecyURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://offerwall.annecy.media?country=%@&language=%@&idfa_gaid=%@&token=%@&user_id=%@&platform=ios", country, language, idfa, TOKEN, USER_ID]];
    NSURLRequest *annecyURLRequest = [NSURLRequest requestWithURL:annecyURL];

    [annecyWebVew loadRequest:annecyURLRequest];
    [self.view addSubview:annecyWebVew];
    [annecyWebVew setDelegate:self];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[request URL] options:@{} completionHandler:nil];

        return NO;
    }

    return YES;
}

- (NSString *)idfa {
    if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        NSUUID *identifier = [[ASIdentifierManager sharedManager] advertisingIdentifier];

        return [identifier UUIDString];
    }

    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
```
