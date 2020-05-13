//
//  SCMBEventProxy.m
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMBEventProxy.h"
extern NSString *const kSCMediaBrowserDismissAction;
extern NSString *const kSCMBImageCellPanDragAlphaChanged;
extern NSString *const kSCMBDisplayingIndexChangedAction;
extern NSString *const kSCMBPropertyStringForCurrentIndex;
extern NSString *const kSCMBPropertyStringForCurrentResource;

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
        resource.attachment.originContentView.superview.transform = CGAffineTransformIdentity;
        resource.attachment.originContentView.superview.frame = self.browser.bounds;
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
        [self.browser.delegate mediaBrowser:self.browser resource:resource downloadProgress:resource.downloadProgress];
    }
}

- (void)collectionView:(UICollectionView *)collectionView displayingResource:(SCMBResource *)resource index:(NSInteger)index {
    
    [self.browser setValue:@(index) forKey:kSCMBPropertyStringForCurrentIndex];
    [self.browser setValue:resource forKey:kSCMBPropertyStringForCurrentResource];
    
    if (self.browser.delegate && [self.browser.delegate respondsToSelector:@selector(mediaBrowser:displayingResource:forItemAtIndex:)]) {
        [self.browser.delegate mediaBrowser:self.browser displayingResource:resource forItemAtIndex:index];
    }
}

#pragma mark - Lazy Load

- (NSDictionary<NSString *,NSInvocation *> *)browserEventStrategy {
    if (!_browserEventStrategy) {
        _browserEventStrategy = @{
            kSCMediaBrowserDismissAction:
                [self createInvocationForSelector:@selector(mediaBrowserImageCellOnceTapGestureActionWithResource:)],
            
            kSCMBImageCellPanDragAlphaChanged:
                [self createInvocationForSelector:@selector(mediaBrowserImageCellPanDragAlphaChanged:)],
            
            kSCMBResourceDownloadProgressAction:
                [self createInvocationForSelector:@selector(resourceDownloadProgress:)],
            
            kSCMBDisplayingIndexChangedAction:
                [self createInvocationForSelector:@selector(collectionView:displayingResource:index:)]
        };
    }
    return _browserEventStrategy;;
}

@end
