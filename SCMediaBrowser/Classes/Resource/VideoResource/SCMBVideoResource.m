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
        self->_loopCount = 1;
        self->_supportResume = NO;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURL:URL coverImageURL:nil];
}

- (instancetype)initWithURL:(NSURL *)URL supportResume:(BOOL)supportResume {
    return [self initWithURL:URL coverImageURL:nil supportResume:supportResume];
}

- (instancetype)initWithURL:(NSURL *)URL supportResume:(BOOL)supportResume resumeDuration:(NSTimeInterval)resumeDuration {
    return [self initWithURL:URL coverImageURL:nil supportResume:supportResume resumeDuration:resumeDuration];
}

- (instancetype)initWithURL:(NSURL *)URL loopCount:(NSInteger)loopCount {
    return [self initWithURL:URL coverImageURL:nil placeholder:nil loopCount:loopCount];
}

- (instancetype)initWithURL:(NSURL *)URL loopCount:(NSInteger)loopCount supportResume:(BOOL)supportResume {
    return [self initWithURL:URL coverImageURL:nil placeholder:nil loopCount:loopCount supportResume:supportResume];
}

- (instancetype)initWithURL:(NSURL *)URL loopCount:(NSInteger)loopCount supportResume:(BOOL)supportResume resumeDuration:(NSTimeInterval)resumeDuration {
    return [self initWithURL:URL coverImageURL:nil placeholder:nil loopCount:loopCount supportResume:supportResume resumeDuration:resumeDuration];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:nil];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL supportResume:(BOOL)supportResume {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:nil supportResume:supportResume];;
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL supportResume:(BOOL)supportResume resumeDuration:(NSTimeInterval)resumeDuration {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:nil supportResume:supportResume resumeDuration:resumeDuration];;
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL loopCount:(NSInteger)loopCount {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:nil loopCount:loopCount];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL loopCount:(NSInteger)loopCount supportResume:(BOOL)supportResume {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:nil loopCount:loopCount supportResume:supportResume];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL loopCount:(NSInteger)loopCount supportResume:(BOOL)supportResume resumeDuration:(NSTimeInterval)resumeDuration {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:nil loopCount:loopCount supportResume:supportResume resumeDuration:resumeDuration];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:placeholder loopCount:1];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder supportResume:(BOOL)supportResume {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:placeholder loopCount:1 supportResume:supportResume];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder supportResume:(BOOL)supportResume resumeDuration:(NSTimeInterval)resumeDuration {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:placeholder loopCount:1 supportResume:supportResume resumeDuration:resumeDuration];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder loopCount:(NSInteger)loopCount {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:placeholder loopCount:loopCount supportResume:NO];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder loopCount:(NSInteger)loopCount supportResume:(BOOL)supportResume {
    return [self initWithURL:URL coverImageURL:coverImageURL placeholder:placeholder loopCount:loopCount supportResume:supportResume resumeDuration:0];
}

- (instancetype)initWithURL:(NSURL *)URL coverImageURL:(NSURL *)coverImageURL placeholder:(UIImage *)placeholder loopCount:(NSInteger)loopCount supportResume:(BOOL)supportResume resumeDuration:(NSTimeInterval)resumeDuration {
    if (self = [self init]) {
        self->_URL = URL;
        self->_coverImageURL = coverImageURL;
        if (!placeholder) {
            placeholder = [UIImage bundleImageNamed:@"placeholder"];
        }
        self->_placeholder = placeholder;
        self->_loopCount = loopCount;
        self->_supportResume = supportResume;
        self->_resumeDuration = resumeDuration;
    }
    return self;
}

@end
