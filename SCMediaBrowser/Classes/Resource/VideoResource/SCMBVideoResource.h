//
//  SCMBVideoResource.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMBResource.h"
#import "SCMBResourceData.h"

@interface SCMBVideoResource : SCMBResource <SCMBResourceData>

@property (nonatomic, strong, readonly) NSURL *coverImageURL;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder;

@end
