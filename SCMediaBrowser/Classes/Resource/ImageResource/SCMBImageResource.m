//
//  SCMBImageResource.m
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMBImageResource.h"
#import "UIImage+BundleImage.h"

NSString *const kSCMBResourceDownloadProgressAction = @"kSCMBResourceDownloadProgressAction";
NSString *const kSCMBResourcePropertyStringForDownloadProgress = @"downloadProgress";

@implementation SCMBImageResource

@synthesize URL = _URL;
@synthesize placeholder = _placeholder;

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURL:URL placeholder:nil];
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self->_image = image;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL placeholder:(UIImage *)placeholder {
    if (self = [super init]) {
        self->_URL = URL;
        if (!placeholder) {
            placeholder = [UIImage bundleImageNamed:@"placeholder"];
        }
        self->_placeholder = placeholder;
    }
    return self;
}

+ (instancetype)resourceWithURL:(NSURL *)URL {
    return [self resourceWithURL:URL placeholder:nil];
}

+ (instancetype)resourceWithImage:(UIImage *)image {
    return [[self alloc] initWithImage:image];
}

+ (instancetype)resourceWithURL:(NSURL *)URL placeholder:(UIImage *)placeholder {
    return [[self alloc] initWithURL:URL placeholder:placeholder];
}

@end
