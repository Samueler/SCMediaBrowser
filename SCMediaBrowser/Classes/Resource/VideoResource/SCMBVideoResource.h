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
@property (nonatomic, assign, readonly) NSTimeInterval resumeDuration;
@property (nonatomic, assign, getter=isSupportResume, readonly) BOOL supportResume;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithURL:(NSURL *)URL loopCount:(NSInteger)loopCount;
- (instancetype)initWithURL:(NSURL *)URL loopCount:(NSInteger)loopCount supportResume:(BOOL)supportResume;
- (instancetype)initWithURL:(NSURL *)URL loopCount:(NSInteger)loopCount supportResume:(BOOL)supportResume resumeDuration:(NSTimeInterval)resumeDuration;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL supportResume:(BOOL)supportResume;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL supportResume:(BOOL)supportResume resumeDuration:(NSTimeInterval)resumeDuration;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL loopCount:(NSInteger)loopCount;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL loopCount:(NSInteger)loopCount supportResume:(BOOL)supportResume;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL loopCount:(NSInteger)loopCount supportResume:(BOOL)supportResume resumeDuration:(NSTimeInterval)resumeDuration;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder supportResume:(BOOL)supportResume;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder supportResume:(BOOL)supportResume resumeDuration:(NSTimeInterval)resumeDuration;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder loopCount:(NSInteger)loopCount;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder loopCount:(NSInteger)loopCount supportResume:(BOOL)supportResume;
- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder loopCount:(NSInteger)loopCount supportResume:(BOOL)supportResume resumeDuration:(NSTimeInterval)resumeDuration;

@end
