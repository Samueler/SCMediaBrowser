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

- (instancetype)init {
    if (self = [super init]) {
        _loopCount = 1;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURL:URL coverImageURL:nil];
}

- (instancetype)initWithURL:(NSURL *)URL loopCount:(NSInteger)loopCount {
    return [self initWithURL:URL coverImageURL:nil placeholder:nil loopCount:loopCount];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:nil];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL loopCount:(NSInteger)loopCount {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:nil loopCount:loopCount];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:placeholder loopCount:1];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder loopCount:(NSInteger)loopCount {
    if (self = [self init]) {
        self->_URL = URL;
        self->_coverImageURL = coverImageURL;
        if (!placeholder) {
            placeholder = [UIImage bundleImageNamed:@"placeholder"];
        }
        self->_placeholder = placeholder;
        self->_loopCount = loopCount;
    }
    return self;
}

@end
