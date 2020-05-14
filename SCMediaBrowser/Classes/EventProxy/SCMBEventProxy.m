//
//  SCMBEventProxy.m
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMBEventProxy.h"
#import "SCMBImageResource.h"
#import "SCMBVideoResource.h"

extern NSString *const kSCMediaBrowserDismissAction;
extern NSString *const kSCMBDisplayingIndexChangedAction;
extern NSString *const kSCMediaBrowserVideoStatusChanged;
extern NSString *const kSCMBPropertyStringForCurrentIndex;
extern NSString *const kSCMediaBrowserVideoDurationChanged;
extern NSString *const kSCMBResourceDownloadProgressAction;
extern NSString *const kSCMBResourceCellPanDragAlphaChanged;
extern NSString *const kSCMBPropertyStringForCurrentResource;
extern NSString *const kSCMediaBrowserVideoBufferDurationChanged;

@interface SCMBEventProxy ()

@property (nonatomic, strong) NSDictionary<NSString *, NSInvocation *> *browserEventStrategy;

@end

@implementation SCMBEventProxy

- (instancetype)init {
    if (self = [super init]) {
        self.eventStrategy = self.browserEventStrategy;
    }
    return self;
}

#pragma mark - Events

- (void)mediaBrowserImageCellOnceTapGestureActionWithResource:(SCMBResource *)resource {
    
    CGRect targetF = [resource.attachment.thumbnailContentView convertRect:resource.attachment.thumbnailContentView.bounds toView:self.browser];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.browser.backgroundColor = [self.browser.backgroundColor colorWithAlphaComponent:0];
        if ([resource isKindOfClass:[SCMBImageResource class]]) {
            resource.attachment.originContentView.superview.transform = CGAffineTransformIdentity;
            resource.attachment.originContentView.superview.frame = self.browser.bounds;
        }
        resource.attachment.originContentView.transform = resource.attachment.thumbnailContentView.transform;
        resource.attachment.originContentView.contentMode = resource.attachment.thumbnailContentView.contentMode;
        resource.attachment.originContentView.clipsToBounds = resource.attachment.thumbnailContentView.clipsToBounds;
        resource.attachment.originContentView.layer.masksToBounds = resource.attachment.thumbnailContentView.layer.masksToBounds;
        resource.attachment.originContentView.frame = targetF;
        
    } completion:^(BOOL finished) {
        [self.browser dismissMediaBrowser];
    }];
}

- (void)mediaBrowserImageCellPanDragAlphaChanged:(float)alpha {
    self.browser.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
    [self.browser setValue:@(alpha == 1) forKeyPath:@"collectionView.scrollEnabled"];
}

- (void)resourceDownloadProgress:(SCMBResource *)resource {
    if (self.browser.delegate && [self.browser.delegate respondsToSelector:@selector(mediaBrowser:resource:downloadProgress:)]) {
        [self.browser.delegate mediaBrowser:self.browser resource:resource downloadProgress:[(SCMBImageResource *)resource downloadProgress]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView displayingResource:(SCMBResource *)resource index:(NSInteger)index {
    
    [self.browser setValue:@(index) forKey:kSCMBPropertyStringForCurrentIndex];
    [self.browser setValue:resource forKey:kSCMBPropertyStringForCurrentResource];
    
    if (self.browser.delegate && [self.browser.delegate respondsToSelector:@selector(mediaBrowser:displayingResource:forItemAtIndex:)]) {
        [self.browser.delegate mediaBrowser:self.browser displayingResource:resource forItemAtIndex:index];
    }
}

- (void)videoResourceBufferDurationChanged:(NSTimeInterval)bufferedDuration {
    if (self.browser.delegate && [self.browser.delegate respondsToSelector:@selector(mediaBrowser:bufferedDuration:index:)]) {
        [self.browser.delegate mediaBrowser:self.browser bufferedDuration:bufferedDuration index:self.browser.currentIndex];
    }
}

- (void)videoResourceCurrentDuration:(NSTimeInterval)currentDuration totalDuration:(NSTimeInterval)totalDuration {
    if (self.browser.delegate && [self.browser.delegate respondsToSelector:@selector(mediaBrowser:currentDuration:totalDuration:)]) {
        [self.browser.delegate mediaBrowser:self.browser currentDuration:currentDuration totalDuration:totalDuration index:self.browser.currentIndex];
    }
}

- (void)videoResourceCurrentItemStatusChanged:(SCAVPlayerStatus)status {
    if (self.browser.delegate && [self.browser.delegate respondsToSelector:@selector(mediaBrowser:currentStatusChanged:)]) {
        [self.browser.delegate mediaBrowser:self.browser currentStatusChanged:status index:self.browser.currentIndex];
    }
}

#pragma mark - Lazy Load

- (NSDictionary<NSString *,NSInvocation *> *)browserEventStrategy {
    if (!_browserEventStrategy) {
        _browserEventStrategy = @{
            kSCMediaBrowserDismissAction:
                [self createInvocationForSelector:@selector(mediaBrowserImageCellOnceTapGestureActionWithResource:)],
            
            kSCMBResourceCellPanDragAlphaChanged:
                [self createInvocationForSelector:@selector(mediaBrowserImageCellPanDragAlphaChanged:)],
            
            kSCMBResourceDownloadProgressAction:
                [self createInvocationForSelector:@selector(resourceDownloadProgress:)],
            
            kSCMBDisplayingIndexChangedAction:
                [self createInvocationForSelector:@selector(collectionView:displayingResource:index:)],
            
            kSCMediaBrowserVideoBufferDurationChanged:
                [self createInvocationForSelector:@selector(videoResourceBufferDurationChanged:)],
            
            kSCMediaBrowserVideoDurationChanged:
                [self createInvocationForSelector:@selector(videoResourceCurrentDuration:totalDuration:)],
            
            kSCMediaBrowserVideoStatusChanged:
                [self createInvocationForSelector:@selector(videoResourceCurrentItemStatusChanged:)]
        };
    }
    return _browserEventStrategy;;
}

@end
