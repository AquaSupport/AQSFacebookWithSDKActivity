//
//  AQSFacebookWithSDKActivityTests.m
//  AQSFacebookWithSDKActivityTests
//
//  Created by kaiinui on 2014/11/11.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock.h>

#import <FacebookSDK.h>

#import "AQSFacebookWithSDKActivity.h"

@interface AQSFacebookWithSDKActivityTests : XCTestCase

@property AQSFacebookWithSDKActivity *activity;

@end

@implementation AQSFacebookWithSDKActivityTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testItsActivityCategoryIsShare {
    XCTAssertTrue(AQSFacebookWithSDKActivity.activityCategory == UIActivityCategoryShare);
}

- (void)testItReturnsItsImage {
    XCTAssertNotNil(_activity.activityImage);
}

- (void)testItReturnsItsType {
    XCTAssertTrue([_activity.activityType isEqualToString:@"org.openaquamarine.facebook.sdk"]);
}

- (void)testItReturnsItsTitle {
    XCTAssertTrue([_activity.activityTitle isEqualToString:@"Facebook"]);
}

- (void)testItAlwaysAbleToPerformActivity {
    NSArray *activityItems = @[@"hoge", [NSURL URLWithString:@"http://google.com/"]];
    XCTAssertTrue([_activity canPerformWithActivityItems:activityItems]);
}

@end
