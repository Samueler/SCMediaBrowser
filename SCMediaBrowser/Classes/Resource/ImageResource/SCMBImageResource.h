//
//  SCMBImageResource.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMBResource.h"

@interface SCMBImageResource : SCMBResource

@property (nonatomic, strong, readonly) NSURL *URL;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong, readonly) UIImage *placeholder;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithURL:(NSURL *)URL placeholder:(UIImage *)placeholder;

+ (instancetype)resourceWithURL:(NSURL *)URL;
+ (instancetype)resourceWithImage:(UIImage *)image;
+ (instancetype)resourceWithURL:(NSURL *)URL placeholder:(UIImage *)placeholder;

@end
