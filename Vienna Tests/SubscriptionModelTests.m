//
//  SubscriptionModelTests.m
//  Vienna
//
//  Created by Joshua Pore on 5/10/2014.
//  Copyright (c) 2014 uk.co.opencommunity. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "SubscriptionModel.h"
#import "NSURL+URIEquivalence.h"

@interface SubscriptionModelTests : XCTestCase {
    SubscriptionModel *subscriptionModel;
}

@end

@implementation SubscriptionModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    subscriptionModel = [[SubscriptionModel alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    subscriptionModel = nil;
}

- (void)testVerificationOfCompleteFileURLs {
    // Test that when passed a complete file URL, the verification doesn't change the original
    NSURL *unverifiedURL = [NSURL URLWithString:@"file:///Users/test/test.xml"];
    NSURL *expectedURL = [NSURL URLWithString:@"file:///Users/test/test.xml"];
    
    XCTAssertEqualObjects(expectedURL, [subscriptionModel verifiedFeedURLFromURL:unverifiedURL]);
}

- (void)testVerificationOfCompleteWebURLs {
    // Test that then passed a complete web URL to an rss feed, the verification doesn't change the original
    NSURL *unverifiedURL = [NSURL URLWithString:@"https://www.vienna-rss.com/feed.xml"];
    NSURL *expectedURL = [NSURL URLWithString:@"https://www.vienna-rss.com/feed.xml"];
    
    XCTAssertEqualObjects(expectedURL, [subscriptionModel verifiedFeedURLFromURL:unverifiedURL]);
}

- (void)testVerificationOfIncompleteWebURLs {
    // Test that when passed a URL without an rss feed in the path component and without a scheme
    // that the returned URL is correct
    NSURL *unverifiedURL = [NSURL URLWithString:@"www.vienna-rss.com"];
    NSURL *expectedURL = [NSURL URLWithString:@"https://www.vienna-rss.com/feed.xml"];

    NSURL *verifiedURL = [subscriptionModel verifiedFeedURLFromURL:unverifiedURL];

    XCTAssertTrue([expectedURL isEquivalent:verifiedURL]);
}

- (void)testVerificationOfHostRelativeWebURLs {
    // Test that when passed a URL without an rss feed in the path component and without a scheme
    // that the returned URL is correct
    NSURL *unverifiedURL = [NSURL URLWithString:@"https://news.ycombinator.com/news"];
    NSURL *expectedURL = [NSURL URLWithString:@"https://news.ycombinator.com/rss"];

    NSURL *verifiedURL = [subscriptionModel verifiedFeedURLFromURL:unverifiedURL];

    XCTAssertTrue([expectedURL isEquivalent:verifiedURL]);
    
    // Reported by @cdevroe from https://twitter.com/cdevroe/status/517764086478958593
    unverifiedURL = [NSURL URLWithString:@"https://adactio.com/journal/"];
    expectedURL = [NSURL URLWithString:@"https://adactio.com/journal/rss"];

    verifiedURL = [subscriptionModel verifiedFeedURLFromURL:unverifiedURL];

    XCTAssertTrue([expectedURL isEquivalent:verifiedURL]);
    
    // Reported by @cdevroe from from https://twitter.com/cdevroe/status/517764395183915009
    unverifiedURL = [NSURL URLWithString:@"shawnblanc.net"];
    expectedURL = [NSURL URLWithString:@"http://shawnblanc.net/feed/"];

    verifiedURL = [subscriptionModel verifiedFeedURLFromURL:unverifiedURL];

    XCTAssertTrue([expectedURL isEquivalent:verifiedURL]);
}

@end
