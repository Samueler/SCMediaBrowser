//
//  SCMBImageCell.m
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMBImageCell.h"
#import "SDWebImage.h"
#import "SCMBImageScrollView.h"
#import "UIResponder+SCRouter.h"

NSString *const kSCMediaBrowserDismissAction = @"kSCMediaBrowserDismissAction";
NSString *const kSCMBImageCellPanDragAlphaChanged = @"kSCMBImageCellPanDragAlphaChanged";

@interface SCMBImageCell () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) SCMBImageScrollView *imageScrollView;
@property (nonatomic, strong) UITapGestureRecognizer *onceTapGesture;
@property (nonatomic, strong) UITapGestureRecognizer *twiceTapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, assign) BOOL startDrag;
@property (nonatomic, assign) CGPoint startDragPoint;

@end

@implementation SCMBImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Private Functions

- (void)commonInit {
    [self addSubview:self.imageScrollView];
    self.imageScrollView.frame = self.bounds;
    
    [self addGestureRecognizer:self.onceTapGesture];
    [self addGestureRecognizer:self.twiceTapGesture];
    [self addGestureRecognizer:self.panGesture];
    
    [self.onceTapGesture requireGestureRecognizerToFail:self.twiceTapGesture];
    [self.onceTapGesture requireGestureRecognizerToFail:self.panGesture];
    [self.twiceTapGesture requireGestureRecognizerToFail:self.panGesture];
}

- (void)resetScrollView {
    self.imageScrollView.zoomScale = 1;
    self.imageScrollView.contentOffset = CGPointZero;
}

- (void)setupImageScrollViewWithOriginSize:(CGSize)originSize {
    
    [self resetScrollView];
    
    CGFloat x = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = width * originSize.height / originSize.width;
    CGFloat tempY = (self.frame.size.height - height) * 0.5;
    CGFloat y = tempY < 0 ? 0 : tempY;
    
    CGRect contentImgViewFrame = CGRectMake(x, y, width, height);
    self.imageScrollView.contentImgView.frame = contentImgViewFrame;
    
    self.imageScrollView.contentSize = CGSizeMake(MAX(self.frame.size.width, width), MAX(self.frame.size.height, height));
    self.imageScrollView.maximumZoomScale = 3;
}

- (void)setupDownloadProgressWithProgress:(float)progress {
    [self.resource setValue:@(progress) forKey:kSCMBResourcePropertyStringForDownloadProgress];
    [self routerEventForName:kSCMBResourceDownloadProgressAction paramater:self.resource];
}

- (void)hideAddedAttachments {
    for (UIView *subview in self.subviews) {
        if (!([subview isEqual:self.contentView] || [subview isEqual:self.imageScrollView])) {
            subview.hidden = YES;
        }
    }
}

#pragma mark - Events

- (void)onceTapGestureAction:(UITapGestureRecognizer *)onceTapGesture {
    [self resetScrollView];
    [self hideAddedAttachments];
    [self routerEventForName:kSCMediaBrowserDismissAction paramater:self.resource];
}

- (void)doubleTapGestureAction:(UITapGestureRecognizer *)doubleTapGesture {
    
    CGPoint point = [doubleTapGesture locationInView:self.imageScrollView.contentImgView];
    if (self.imageScrollView.zoomScale == self.imageScrollView.maximumZoomScale) {
        [self.imageScrollView setZoomScale:1 animated:YES];
    } else {
        [self.imageScrollView zoomToRect:CGRectMake(point.x, point.y, 1, 1) animated:YES];
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    CGPoint touchPoint = [panGesture locationInView:self];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.startDragPoint = touchPoint;
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        if (self.startDrag) {
            self.imageScrollView.layer.position = touchPoint;
            CGFloat scale = 1 - ABS(touchPoint.y - self.startDragPoint.y) / (self.frame.size.height * 1.2);
            if (scale > 1) {
                scale = 1;
            }
            
            if (scale < 0.35) {
                scale = 0.35;
            }
            
            self.imageScrollView.transform = CGAffineTransformMakeScale(scale, scale);
            CGFloat alpha = 1 - ABS(touchPoint.y - self.startDragPoint.y) / (self.frame.size.height * 0.7);
            if (alpha > 1) {
                alpha = 1;
            }
            
            if (alpha < 0) {
                alpha = 0;
            }
            
            [self routerEventForName:kSCMBImageCellPanDragAlphaChanged paramater:@(alpha)];
        } else {
            if (CGPointEqualToPoint(self.startDragPoint, CGPointZero) || self.imageScrollView.isZooming || !self.resource.attachment.panGestureEnable) {
                return;
            }
            
            CGPoint velocity = [panGesture velocityInView:self.imageScrollView];
            CGFloat minDragDistance = 3;
            CGFloat offsetY = self.imageScrollView.contentOffset.y;
            CGFloat height = self.imageScrollView.frame.size.height;
            
            BOOL distanceArrive = ABS(touchPoint.x - self.startDragPoint.x) < minDragDistance && ABS(velocity.x) < 500;
            BOOL upArrive = touchPoint.y - self.startDragPoint.y > minDragDistance && offsetY <= 1;
            BOOL downArrive = touchPoint.y - self.startDragPoint.y < -minDragDistance && offsetY + height >= MAX(self.imageScrollView.contentSize.height, height) - 1;
            BOOL shouldStart = (upArrive || downArrive) && distanceArrive;
            if (!shouldStart) {
                return;
            }
            
            self.startDragPoint = touchPoint;
            CGRect startF = self.imageScrollView.frame;
            CGFloat anchorX = touchPoint.x / startF.size.width;
            CGFloat anchorY = touchPoint.y / startF.size.height;
            self.imageScrollView.layer.anchorPoint = CGPointMake(anchorX, anchorY);
            
            self.imageScrollView.scrollEnabled = NO;
            self.imageScrollView.userInteractionEnabled = NO;
            self.imageScrollView.center = touchPoint;
            [self hideAddedAttachments];
            
            self.startDrag = YES;
        }
    } else if (panGesture.state >= UIGestureRecognizerStateEnded) {
        if (self.startDrag) {
            CGPoint velocity = [panGesture velocityInView:self.imageScrollView];
            CGFloat dismissVelocityY = 800;
            CGFloat dismissScale = 0.22;
            
            BOOL velocityArrive = ABS(velocity.y) > dismissVelocityY;
            BOOL distanceArrive = ABS(touchPoint.y - self.startDragPoint.y) > self.frame.size.height * dismissScale;
              
            BOOL shouldDismiss = distanceArrive || velocityArrive;
            if (shouldDismiss) {
                [self resetScrollView];
                [self routerEventForName:kSCMediaBrowserDismissAction paramater:self.resource];
            } else {
                [self hideAddedAttachments];
                [UIView animateWithDuration:0.25 animations:^{
                    [self routerEventForName:kSCMBImageCellPanDragAlphaChanged paramater:@(1)];
                    CGPoint anchorPoint = self.imageScrollView.layer.anchorPoint;
                    self.imageScrollView.center = CGPointMake(self.frame.size.width * anchorPoint.x, self.frame.size.height * anchorPoint.y);
                    self.imageScrollView.transform = CGAffineTransformIdentity;
                    self.startDragPoint = CGPointZero;
                } completion:^(BOOL finished) {
                    self.imageScrollView.layer.anchorPoint = CGPointMake(0.5, 0.5);
                    self.imageScrollView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
                    self.imageScrollView.userInteractionEnabled = YES;
                    self.imageScrollView.scrollEnabled = YES;
                    
                    [self routerEventForName:kSCMBImageCellPanDragAlphaChanged paramater:@(1)];
                    
                    self.startDrag = NO;
                }];
              }
          }
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageScrollView.contentImgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect contentImgViewF = self.imageScrollView.contentImgView.frame;
    CGFloat contentImgViewWidth = contentImgViewF.size.width;
    CGFloat contentImgViewHeight = contentImgViewF.size.height;
    CGFloat scrollViewWidth = self.imageScrollView.frame.size.width;
    CGFloat scrollViewHeight = self.imageScrollView.frame.size.height;
    
    if (contentImgViewHeight > scrollViewHeight) {
        contentImgViewF.origin.y = 0;
    } else {
        contentImgViewF.origin.y = (scrollViewHeight - contentImgViewHeight) * 0.5;
    }
    
    if (contentImgViewWidth > scrollViewWidth) {
        contentImgViewF.origin.x = 0;
    } else {
        contentImgViewF.origin.x = (scrollViewWidth - contentImgViewWidth) * 0.5;
    }
    
    self.imageScrollView.contentImgView.frame = contentImgViewF;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Setter

- (void)setResource:(SCMBImageResource *)resource {
    _resource = resource;
    
    self.resource.attachment.originContentView = self.imageScrollView.contentImgView;
    
    for (UIView *subview in self.subviews) {
        if ([subview isEqual:self.contentView] || [subview isEqual:self.imageScrollView]) {
            subview.hidden = NO;
        } else {
            subview.hidden = !self.resource.attachment.addedAttachmentView;
        }
    }
    
    if (resource.image) {
        self.imageScrollView.contentImgView.image = resource.image;
        [self setupDownloadProgressWithProgress:1];
    } else {
        
        [self.imageScrollView.contentImgView sd_setImageWithURL:resource.URL placeholderImage:resource.placeholder options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            if (expectedSize == 0) {
                [self setupDownloadProgressWithProgress:0];
                return;
            }
            
            [self setupDownloadProgressWithProgress:receivedSize * 0.1 / expectedSize];
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image && CGSizeEqualToSize(resource.attachment.originSize, image.size) && !error) {
                resource.attachment.originSize = image.size;
                [self setupImageScrollViewWithOriginSize:resource.attachment.originSize];
                [self setupDownloadProgressWithProgress:1];
            }
        }];
    }
    
    [self setupImageScrollViewWithOriginSize:resource.attachment.originSize];
}

#pragma mark - Getter

- (UIView *)imageContentView {
    return self.imageScrollView.contentImgView;
}

#pragma mark - Lazy Load

- (SCMBImageScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [[SCMBImageScrollView alloc] init];
        _imageScrollView.delegate = self;
    }
    return _imageScrollView;
}

- (UITapGestureRecognizer *)onceTapGesture {
    if (!_onceTapGesture) {
        _onceTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onceTapGestureAction:)];
        _onceTapGesture.numberOfTapsRequired = 1;
    }
    return _onceTapGesture;
}

- (UITapGestureRecognizer *)twiceTapGesture {
    if (!_twiceTapGesture) {
        _twiceTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureAction:)];
        _twiceTapGesture.numberOfTapsRequired = 2;
    }
    return _twiceTapGesture;
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
