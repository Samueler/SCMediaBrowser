//
//  SCMBVideoCell.m
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMBVideoCell.h"
#import "SDWebImage.h"
#import "UIResponder+SCRouter.h"

extern NSString *const kSCMediaBrowserDismissAction;
extern NSString *const kSCMBResourceCellPanDragAlphaChanged;

NSString *const kSCMediaBrowserVideoStatusChanged = @"kSCMediaBrowserVideoStatusChanged";
NSString *const kSCMediaBrowserVideoDurationChanged = @"kSCMediaBrowserVideoDurationChanged";
NSString *const kSCMediaBrowserVideoBufferDurationChanged = @"kSCMediaBrowserVideoBufferDurationChanged";

@interface SCMBVideoCell () <
SCAVSinglePlayerDelegate,
UIGestureRecognizerDelegate
>

@property (nonatomic, strong) SCAVSinglePlayer *avPlayer;
@property (nonatomic, strong) UIView *videoContainView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, assign) BOOL startDrag;
@property (nonatomic, assign) CGPoint startDragPoint;

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
    [self addSubview:self.videoContainView];
    [self.videoContainView addSubview:self.coverImageView];
    [self.videoContainView addGestureRecognizer:self.panGesture];
}

- (void)hideAddedAttachments {
    for (UIView *subview in self.subviews) {
        if (!([subview isEqual:self.contentView] || [subview isEqual:self.videoContainView])) {
            subview.hidden = YES;
        }
    }
}

- (void)setupVideoContainerOriginRect {
    CGFloat height = self.frame.size.width * self.resource.attachment.originSize.height / self.resource.attachment.originSize.width;
    height = height > self.frame.size.height ? self.frame.size.height : height;
    
    self.videoContainView.frame = CGRectMake(0, (self.frame.size.height - height) * 0.5, self.frame.size.width, height);
}

#pragma mark - Events

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    CGPoint touchPoint = [panGesture locationInView:self];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.startDragPoint = touchPoint;
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        if (self.startDrag) {
            self.videoContainView.layer.position = touchPoint;
            CGFloat scale = 1 - ABS(touchPoint.y - self.startDragPoint.y) / (self.frame.size.height * 1.2);
            if (scale > 1) {
                scale = 1;
            }
            
            if (scale < 0.35) {
                scale = 0.35;
            }
            
            self.videoContainView.transform = CGAffineTransformMakeScale(scale, scale);
            CGFloat alpha = 1 - ABS(touchPoint.y - self.startDragPoint.y) / (self.frame.size.height * 0.7);
            if (alpha > 1) {
                alpha = 1;
            }
            
            if (alpha < 0) {
                alpha = 0;
            }
            
            [self routerEventForName:kSCMBResourceCellPanDragAlphaChanged paramater:@(alpha)];
        } else {
            if (CGPointEqualToPoint(self.startDragPoint, CGPointZero) || !self.resource.attachment.panGestureEnable) {
                return;
            }
            
            CGPoint velocity = [panGesture velocityInView:self.videoContainView];
            CGFloat minDragDistance = 3;
            BOOL distanceArrive = ABS(touchPoint.x - self.startDragPoint.x) < minDragDistance && ABS(velocity.x) < 500;
            BOOL shouldStart = distanceArrive;
            if (!shouldStart) {
                return;
            }
            
            self.startDragPoint = touchPoint;
            CGRect startF = self.videoContainView.frame;
            CGFloat anchorX = (touchPoint.x - startF.origin.x) / startF.size.width;
            CGFloat anchorY = (touchPoint.y - startF.origin.y) / startF.size.height;
            self.videoContainView.layer.anchorPoint = CGPointMake(anchorX, anchorY);
            self.videoContainView.userInteractionEnabled = NO;
            self.videoContainView.center = touchPoint;
            
            [self hideAddedAttachments];
            
            self.startDrag = YES;
        }
    } else if (panGesture.state >= UIGestureRecognizerStateEnded) {
        if (self.startDrag) {
            CGPoint velocity = [panGesture velocityInView:self.videoContainView];
            CGFloat dismissVelocityY = 800;
            CGFloat dismissScale = 0.22;
            
            BOOL velocityArrive = ABS(velocity.y) > dismissVelocityY;
            BOOL distanceArrive = ABS(touchPoint.y - self.startDragPoint.y) > self.frame.size.height * dismissScale;
              
            BOOL shouldDismiss = distanceArrive || velocityArrive;
            if (shouldDismiss) {
                [self routerEventForName:kSCMediaBrowserDismissAction paramater:self.resource];
            } else {
                [self hideAddedAttachments];

                self.videoContainView.transform = CGAffineTransformIdentity;
                [UIView animateWithDuration:0.25 animations:^{
                    [self routerEventForName:kSCMBResourceCellPanDragAlphaChanged paramater:@(1)];
                    [self setupVideoContainerOriginRect];
                    self.startDragPoint = CGPointZero;
                } completion:^(BOOL finished) {
                    self.videoContainView.userInteractionEnabled = YES;
                    
                    [self routerEventForName:kSCMBResourceCellPanDragAlphaChanged paramater:@(1)];
                    
                    self.startDrag = NO;
                }];
              }
          }
    }
}

#pragma mark - SCAVSinglePlayerDelegate

- (void)singlePlayer:(SCAVSinglePlayer *)singlePlayer currentStatusChanged:(SCAVPlayerStatus)status {
    if (status == SCAVPlayerStatusPlaying) {
        self.coverImageView.hidden = YES;
    }
    
    [self routerEventForName:kSCMediaBrowserVideoStatusChanged paramater:@(status)];
}

- (void)singlePlayer:(SCAVSinglePlayer *)singlePlayer bufferedDuration:(NSTimeInterval)bufferedDuration {
    [self routerEventForName:kSCMediaBrowserVideoBufferDurationChanged paramater:@(bufferedDuration)];
}

- (void)singlePlayer:(SCAVSinglePlayer *)singlePlayer currentDuration:(NSTimeInterval)currentDuration totalDuration:(NSTimeInterval)totalDuration {
    [self.resource setValue:@(currentDuration) forKey:@"resumeDuration"];
    [self routerEventForName:kSCMediaBrowserVideoDurationChanged paramaters:@[@(currentDuration), @(totalDuration)]];
}

- (void)singlePlayerWillEnterForeground:(SCAVSinglePlayer *)singlePlayer {
    [self.avPlayer play];
}

- (void)singlePlayerDidEnterBackground:(SCAVSinglePlayer *)singlePlayer {
    [self.avPlayer pause];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Setter

- (void)setResource:(SCMBVideoResource *)resource {
    _resource = resource;
    
    for (UIView *subview in self.subviews) {
        if ([subview isEqual:self.contentView] || [subview isEqual:self.videoContainView]) {
            subview.hidden = NO;
        } else {
            subview.hidden = !self.resource.attachment.addedAttachmentView;
        }
    }
    
    self.resource.attachment.originContentView = self.videoContainView;
    [self.coverImageView sd_setImageWithURL:resource.coverImageURL placeholderImage:resource.placeholder];
    
    [self setupVideoContainerOriginRect];
    self.coverImageView.frame = self.coverImageView.bounds;
    
    [self.avPlayer.playerLayer removeFromSuperlayer];
    self.avPlayer = [[SCAVSinglePlayer alloc] initWithURL:resource.URL loopCount:resource.loopCount];
    self.avPlayer.delegate = self;
    [self.videoContainView.layer addSublayer:self.avPlayer.playerLayer];
    self.avPlayer.playerLayer.frame = self.videoContainView.bounds;
    if (self.resource.resumeDuration && self.resource.supportResume) {
        [self.avPlayer seekToSecond:self.resource.resumeDuration];
    }
}

#pragma mark - Lazy Load

- (UIView *)videoContainView {
    if (!_videoContainView) {
        _videoContainView = [[UIView alloc] init];
    }
    return _videoContainView;;
}

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
