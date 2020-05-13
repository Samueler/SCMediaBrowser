//
//  SCMBVideoResource.m
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMBVideoResource.h"
#import "UIImage+BundleImage.h"

@implementation SCMBVideoResource

@synthesize URL = _URL;
@synthesize placeholder = _placeholder;

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURL:URL coverImageURL:nil];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:nil];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder {
    if (self = [super init]) {
        self->_URL = URL;
        self->_coverImageURL = coverImageURL;
        if (!placeholder) {
            placeholder = [UIImage bundleImageNamed:@"placeholder"];
        }
        self->_placeholder = placeholder;
    }
    return self;
}

@end
