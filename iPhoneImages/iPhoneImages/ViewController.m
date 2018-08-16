//
//  ViewController.m
//  iPhoneImages
//
//  Created by Kyla  on 2018-08-16.
//  Copyright © 2018 Kyla . All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iPhoneImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    ///step one Create a new NSURL object from the iPhone image url string.
    NSURL *url = [NSURL URLWithString:@"http://imgur.com/y9MIaCS.png"];

    ///step 2 An NSURLSessionConfiguration object defines the behavior and policies to use when making a request with an NSURLSession object. We can set things like the caching policy on this object. The default system values are good for now, so we'll just grab the default configuration.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    ///step 3 Create an NSURLSession object using our session configuration. Any changes we want to make to our configuration object must be done before this.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
/////////step 4 We create a task that will actually download the image from the server. The session creates and configures the task and the task makes the request. Download tasks retrieve data in the form of a file, and support background downloads and uploads while the app is not running. Check out the NSURLSession API Referece for more info on this. We could optionally use a delegate to get notified when the request has completed, but we're going to use a completion block instead. This block will get called when the network request is complete, weather it was successful or not.
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        If there was an error, we want to handle it straight away so we can fix it. Here we're checking if there was an error, logging the description, then returning out of the block since there's no point in continuing.
        if (error) {
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
//        The download task downloads the file to the iPhone then lets us know the location of the download using a local URL. In order to access this as a UIImage object, we need to first convert the file's binary into an NSData object, then create a UIImage from that data.
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
//        The only thing left to do is display the image on the screen. This is almost as simple as self.iPhoneImageView.image = image; however the networking happens on a background thread and the UI can only be updated on the main thread. This means that we need to make sure that this line of code runs on the main thread.
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // This will run on the main queue
            
            self.iPhoneImageView.image = image; 
        }];
    }];
    
///////step 5 A task is created in a suspended state, so we need to resume it. You can also suspend, resume and cancel tasks whenever we want.
    [downloadTask resume];
    
//Note: As of iOS 9, you need to add a key in your Info.plist file to allow loading of HTTP requests. We need to do this because our image URLs use HTTP instead of HTTPS. Open your Info.plist as Source Code and copy add this key:(key is just the url youre using)
///////////////////////////////////////////////////////////////////////////////////////    go to info plist then make sure the down button is clicked in app transport security settings, then add allow arbitrary loads and set it to yes then at exception domains, then add new item to that and put any name but this is where you add your url in the value
//
//    This will allow less secure connections to any server that isn't using HTTPS.
//
//    Now we can run the app, and the image should download, but we're not doing anything with it yet. Let's change that.
}





@end
