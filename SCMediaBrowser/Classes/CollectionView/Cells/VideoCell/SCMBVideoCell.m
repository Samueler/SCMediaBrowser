//
//  SCMBVideoCell.m
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMBVideoCell.h"
#import "SCMBAVPlayer.h"
#import "SDWebImage.h"

@interface SCMBVideoCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation SCMBVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Private Functions

- (void)commonInit {
    [self addSubview:self.coverImageView];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Setter

- (void)setResource:(SCMBVideoResource *)resource {
    _resource = resource;
    
    [self.coverImageView sd_setImageWithURL:resource.coverImageURL placeholderImage:resource.placeholder];
}

#pragma mark - Lazy Load

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
    }
    return _coverImageView;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        _panGesture.maximumNumberOfTouches = 1;
        _panGesture.delegate = self;
    }
    return _panGesture;
}

@end
