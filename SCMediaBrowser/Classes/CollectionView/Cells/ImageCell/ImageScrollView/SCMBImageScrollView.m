//
//  SCMBImageScrollView.m
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMBImageScrollView.h"

@implementation SCMBImageScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self->_contentImgView = [[SDAnimatedImageView alloc] init];
    self.contentImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImgView.clipsToBounds = YES;
    
    [self addSubview:self.contentImgView];
    
    [self scrollViewConfiguration];
}

- (void)scrollViewConfiguration {
    self.maximumZoomScale = 1.f;
    self.minimumZoomScale = 1.f;
    self.alwaysBounceVertical = NO;
    self.alwaysBounceHorizontal = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

@end
