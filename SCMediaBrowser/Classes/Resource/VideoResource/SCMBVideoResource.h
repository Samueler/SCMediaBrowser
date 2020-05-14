//
//  SCMBVideoResource.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMBResource.h"
#import "SCMBResourceData.h"

@interface SCMBVideoResource : SCMBResource <SCMBResourceData>

/// 视频循环次数，0为无限循环
@property (nonatomic, assign, readonly) NSInteger loopCount;
@property (nonatomic, strong, readonly) NSURL *coverImageURL;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithURL:(NSURL *)URL loopCount:(NSInteger)loopCount;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL loopCount:(NSInteger)loopCount;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder loopCount:(NSInteger)loopCount;

@end
