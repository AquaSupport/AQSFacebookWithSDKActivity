//
//  AQSFacebookWithSDKActivity.m
//  AQSFacebookWithSDKActivity
//
//  Created by kaiinui on 2014/11/13.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQSFacebookWithSDKActivity.h"

#import <Social/Social.h>
#import <FacebookSDK.h>

@interface AQSFacebookWithSDKActivity ()

@property (nonatomic, strong) NSArray *activityItems;

@end

@implementation AQSFacebookWithSDKActivity

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    [super prepareWithActivityItems:activityItems];
    
    self.activityItems = activityItems;
}

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}

- (NSString *)activityType {
    return @"org.openaquamarine.facebook.sdk";
}

- (NSString *)activityTitle {
    return @"Facebook";
}

- (UIImage *)activityImage {
    if ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 8) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"color_%@", NSStringFromClass([self class])]];
    } else {
        return [UIImage imageNamed:NSStringFromClass([self class])];
    }
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)performActivity {
    if ([self isFacebookSDKAvailable] == NO) { return; }
    
    FBLinkShareParams *linkParams = [self nilOrFirstLinkShareParamsFromArray:_activityItems];
    FBPhotoParams *params = [self nilOrFirstPhotoParamsFromArray:_activityItems];
    UIImage *image = [self nilOrFirstImageFromArray:_activityItems];
    NSURL *url = [self nilOrFirstURLFromArray:_activityItems];
    NSString *string = [self firstStringOrEmptyStringFromArray:_activityItems];
    
    if (!!linkParams) {
        [self performSDKShareWithLinkShareParams:linkParams];
    } else if (!!params) {
        [self performSDKShareWithPhotoParams:params];
    } else if (!!image) {
        NSArray *images = [self emptyArrayOrImageArrayFromArray:_activityItems];
        [self performSDKShareWithImages:images];
    } else if (!!url) {
        [self performSDKShareWithURL:url];
    }
}

- (UIViewController *)activityViewController {
    if ([self isFacebookSDKAvailable]) {
        return nil;
    }
    
    SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    return [self activityViewControllerWithComposeViewController:composeViewController];
}

# pragma mark - Helpers (Array)

- (NSArray *)emptyArrayOrImageArrayFromArray:(NSArray *)array {
    NSMutableArray *ma = [NSMutableArray array];
    for (id item in array) {
        if ([item isKindOfClass:[UIImage class]]) {
            [ma addObject:item];
        }
    }
    return ma;
}

- (NSString *)firstStringOrEmptyStringFromArray:(NSArray *)array {
    for (id item in array) {
        if ([item isKindOfClass:[NSString class]]) {
            return item;
        }
    }
    return @"";
}

- (NSURL *)nilOrFirstURLFromArray:(NSArray *)array {
    for (id item in array) {
        if ([item isKindOfClass:[NSURL class]]) {
            return item;
        }
    }
    return nil;
}

- (UIImage *)nilOrFirstImageFromArray:(NSArray *)array {
    for (id item in array) {
        if ([item isKindOfClass:[UIImage class]]) {
            return item;
        }
    }
    return nil;
}

- (FBLinkShareParams *)nilOrFirstLinkShareParamsFromArray:(NSArray *)array {
    for (id item in array) {
        if ([item isKindOfClass:[FBLinkShareParams class]]) {
            return item;
        }
    }
    return nil;
}

- (FBPhotoParams *)nilOrFirstPhotoParamsFromArray:(NSArray *)array {
    for (id item in array) {
        if ([item isKindOfClass:[FBPhotoParams class]]) {
            return item;
        }
    }
    return nil;
}

# pragma mark - Helpers (Facebook SDK)

- (BOOL)isFacebookSDKAvailable {
    return [FBDialogs canPresentShareDialog];
}

- (BOOL)isFacebookSDKAvailableWithPhoto {
    return [FBDialogs canPresentShareDialogWithPhotos];
}

- (void)performSDKShareWithImage:(UIImage *)image {
    [self performSDKShareWithImages:@[image]];
}

- (void)performSDKShareWithImages:(NSArray /* UIImage */ *)images {
    __weak typeof(self) weakSelf = self;
    [FBDialogs presentShareDialogWithPhotos:images handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        [weakSelf handleSDKCallback:call results:results error:error];
    }];
}

- (void)performSDKShareWithURL:(NSURL *)url {
    __weak typeof(self) weakSelf = self;
    [FBDialogs presentShareDialogWithLink:url handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        [weakSelf handleSDKCallback:call results:results error:error];
    }];
}

- (void)performSDKShareWithLinkShareParams:(FBLinkShareParams *)params {
    __weak typeof(self) weakSelf = self;
    [FBDialogs presentShareDialogWithParams:params clientState:@{} handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        [weakSelf handleSDKCallback:call results:results error:error];
    }];
}

- (void)performSDKShareWithPhotoParams:(FBPhotoParams *)params {
    __weak typeof(self) weakSelf = self;
    [FBDialogs presentShareDialogWithPhotoParams:params clientState:@{} handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        [weakSelf handleSDKCallback:call results:results error:error];
    }];
}

- (void)handleSDKCallback:(FBAppCall *)call results:(NSDictionary *)results error:(NSError *)error {
    [self activityDidFinish:(!error)];
}

# pragma mark - Helpers (Social Facebook)

- (UIViewController *)activityViewControllerWithComposeViewController:(SLComposeViewController *)composeViewController {
    [composeViewController setInitialText:[self firstStringOrEmptyStringFromArray:self.activityItems]];
    for (id item in self.activityItems) {
        if ([item isKindOfClass:[UIImage class]]) {
            [composeViewController addImage:item];
        }
    }
    for (id item in self.activityItems) {
        if ([item isKindOfClass:[NSURL class]]) {
            [composeViewController addURL:item];
        }
    }
    __weak typeof(self) weakSelf = self;
    composeViewController.completionHandler = ^(SLComposeViewControllerResult result) {
        BOOL completed = (result == SLComposeViewControllerResultDone);
        [weakSelf activityDidFinish:completed];
    };
    
    return composeViewController;
}

@end
