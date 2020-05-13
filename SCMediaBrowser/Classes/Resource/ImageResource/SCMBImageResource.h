//
//  SCMBImageResource.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMBResource.h"
#import "SCMBResourceData.h"

@interface SCMBImageResource : SCMBResource <SCMBResourceData>

@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, assign, readonly) float downloadProgress;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithURL:(NSURL *)URL placeholder:(UIImage *)placeholder;

+ (instancetype)resourceWithURL:(NSURL *)URL;
+ (instancetype)resourceWithImage:(UIImage *)image;
+ (instancetype)resourceWithURL:(NSURL *)URL placeholder:(UIImage *)placeholder;

@end
