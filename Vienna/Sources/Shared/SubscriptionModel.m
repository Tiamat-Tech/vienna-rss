//
//  SubscriptionModel.m
//  Vienna
//
//  Created by Joshua Pore on 4/10/2014.
//  Copyright (c) 2014 uk.co.opencommunity. All rights reserved.
//

#import "SubscriptionModel.h"
#import "RichXMLParser.h"
#import "StringExtensions.h"

@implementation SubscriptionModel


/*!
* Verifies the specified URL. This is the auto-discovery phase that is described at
* http://diveintomark.org/archives/2002/08/15/ultraliberal_rss_locator
*
* Basically we examine the data at the specified URL and if it is an RSS feed
* then OK. Otherwise if it looks like an HTML page, we scan for links in the
* page text.
*
*  @param feedURLString A pointer to the URL to verify
*
*  @return A pointer to a verified URL
*/
-(NSURL *)verifiedFeedURLFromURL:(NSURL *)rssFeedURL
{
    // If the URL starts with feed or ends with a feed extension then we're going
    // assume it's a feed.
    if ([rssFeedURL.scheme isEqualToString:@"feed"]) {
        return rssFeedURL;
    }
    
    if ([rssFeedURL.pathExtension isEqualToString:@"rss"] || [rssFeedURL.pathExtension isEqualToString:@"rdf"] || [rssFeedURL.pathExtension isEqualToString:@"xml"]) {
        return rssFeedURL;
    }
    
    // OK. Now we're at the point where can't be reasonably sure that
    // the URL points to a feed. Time to look at the content.
    if (rssFeedURL.scheme == nil)
    {
        rssFeedURL = [NSURL URLWithString:[@"http://" stringByAppendingString:rssFeedURL.absoluteString]];
    }

    __block NSURL * myURL;
    // semaphore with count equal to zero for synchronizing completion of work
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:rssFeedURL
      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error || (((NSHTTPURLResponse *)response).statusCode != 200)) {
            myURL = rssFeedURL;
        } else {
            NSMutableArray * linkArray = [NSMutableArray arrayWithCapacity:10];
            // Get all the feeds on the page. If there's more than one, use the first one.
            // TODO : if there are multiple feeds, we should put up an UI inviting the user to pick one
            // That would require modifying extractFeeds to provide URL strings and titles
            // as feeds' links are often advertised in the HTML head
            // as <link rel="alternate" type="application/rss+xml" title="..." href="...">
            if ([RichXMLParser extractFeeds:data toArray:linkArray]) {
                NSString * feedPart = linkArray.firstObject;
                myURL = [NSURL URLWithString:feedPart relativeToURL:rssFeedURL];
                if (myURL == nil) {
                    NSString * urlString = feedPart.stringByUnescapingExtendedCharacters;
                    myURL = [NSURL URLWithString:urlString relativeToURL:rssFeedURL];
                }
            } else {
                // no link found, return the original URL
                myURL = rssFeedURL;
            }
        }
        // Signal that we are done
        dispatch_semaphore_signal(sema);
    }];
    [task resume];
    // Now we wait until the task response block will send a signal
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return myURL;
}


@end
