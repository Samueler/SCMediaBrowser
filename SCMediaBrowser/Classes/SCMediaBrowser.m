//
//  SCMediaBrowser.m
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMediaBrowser.h"
#import "SCMBEventProxy.h"
#import "UIView+SCRouter.h"
#import "SCMBCollectionView.h"
#import "UIImage+BundleImage.h"

NSString *const kSCMBPropertyStringForCurrentIndex = @"currentIndex";
NSString *const kSCMBPropertyStringForCurrentResource = @"currentResource";

@interface SCMediaBrowser () <SCMBCollectionViewDelegate>

@property (nonatomic, strong) SCMBCollectionView *collectionView;
@property (nonatomic, strong) SCMBEventProxy *mediaBrowserEventProxy;
@property (nonatomic, strong) NSMutableArray<SCMBResource *> *internalResources;

@end

@implementation SCMediaBrowser

#pragma mark - Initialization Functions

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithIndex:(NSInteger)index {
    if (self = [super init]) {
        [self commonInit];
        self->_currentIndex = index;
    }
    return self;
}

+ (instancetype)mediaBrowserWithIndex:(NSInteger)index {
    return [[self alloc] initWithIndex:index];
}

#pragma mark - Public Functions

- (void)reloadData {
    [self.internalResources removeAllObjects];
    
    NSInteger resourceNumber = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfResourcesInMediaBrowser:)]) {
        resourceNumber = [self.dataSource numberOfResourcesInMediaBrowser:self];
    }
    
    for (NSInteger idx = 0; idx < resourceNumber; idx++) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(mediaBrowser:resourceAtIndex:)]) {
            SCMBResource *resource = [self.dataSource mediaBrowser:self resourceAtIndex:idx];
            if (!resource.attachment) {
                resource.attachment = [[SCMBResourceAttachment alloc] init];
            }
            if (!resource) {
                NSString *tips = [NSString stringWithFormat:@"resource is nil at index:%zd", idx];
                NSAssert(resource, tips);
                [self.internalResources removeAllObjects];
                return;
            }
            
            [self.internalResources addObject:resource];
        }
        
        SCMBResource *resource = self.internalResources[idx];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(mediaBrowser:thumbnailViewAtIndex:)]) {
            UIImageView *thumbnailImgView = [self.dataSource mediaBrowser:self thumbnailViewAtIndex:idx];
            if (thumbnailImgView) {
                resource.attachment.thumbnailSize = thumbnailImgView.image.size;
                if (CGSizeEqualToSize(resource.attachment.originSize, CGSizeZero)) {
                    resource.attachment.originSize = resource.attachment.thumbnailSize;
                }
                
                resource.attachment.thumbnailContentView = thumbnailImgView;
            }
        }
        
        if (CGSizeEqualToSize(resource.attachment.thumbnailSize, CGSizeZero)) {
            if ([resource isKindOfClass:[SCMBImageResource class]]) {
                SCMBImageResource *imageResource = (SCMBImageResource *)resource;
                resource.attachment.thumbnailSize = imageResource.placeholder.size;
            } else {
                SCMBVideoResource *videoResource = (SCMBVideoResource *)resource;
                videoResource.attachment.thumbnailSize = videoResource.placeholder.size;
            }
            resource.attachment.originSize = resource.attachment.thumbnailSize;
        }
    }
    
    self->_currentResource = self.internalResources[self.currentIndex];
    self.collectionView.resources = self.internalResources;
    
    if (self.currentIndex < self.internalResources.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}

- (void)presentMediaBrowser {
    
    [UIApplication.sharedApplication.delegate.window addSubview:self];
    self.frame = self.superview.bounds;
    
    [self setupUI];
    [self reloadData];
    
    self.collectionView.hidden = YES;
    SCMBResource *resource = self.internalResources[self.currentIndex];
    
    CGFloat x = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = width * resource.attachment.originSize.height / resource.attachment.originSize.width;
    CGFloat tempY = (self.frame.size.height - height) * 0.5;
    CGFloat y = tempY < 0 ? 0 : tempY;
    
    CGRect startF = [resource.attachment.thumbnailContentView convertRect:resource.attachment.thumbnailContentView.frame toView:self];
    CGRect targetF = CGRectMake(x, y, width, height);
    
    __block UIView *animationView = [[UIView alloc] initWithFrame:startF];
    animationView.layer.contents = resource.attachment.thumbnailContentView.layer.contents;
    [self addSubview:animationView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:1];
        animationView.frame = targetF;
    } completion:^(BOOL finished) {
        [animationView removeFromSuperview];
        animationView = nil;
        self.collectionView.hidden = NO;
        
        if (self.currentIndex == 0) {
            [self.delegate mediaBrowser:self displayingResource:self.currentResource forItemAtIndex:self.currentIndex];
        }
    }];
}

- (void)dismissMediaBrowser {
    
    [self.superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:self]) {
            [self removeFromSuperview];
            obj = nil;
        }
    }];
}

#pragma mark - Private Functions

- (void)commonInit {
    self.backgroundColor = [UIColor blackColor];
    self.mediaBrowserEventProxy = [[SCMBEventProxy alloc] init];
    self.mediaBrowserEventProxy.browser = self;
    self.eventProxy = self.mediaBrowserEventProxy;
}

- (void)setupUI {
    [self addSubview:self.collectionView];
    self.collectionView.frame = self.bounds;
}

#pragma mark - SCMBCollectionViewDelegate

- (void)collectionView:(SCMBCollectionView *)collectionView containerView:(UIView *)containerView contentView:(UIView *)contentView cellForItemAtIndex:(NSInteger)index {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(mediaBrowser:containerView:contentView:customAttachmentsForIndex:)]) {
        self.internalResources[index].attachment.addedAttachmentView = [self.dataSource mediaBrowser:self containerView:containerView contentView:contentView customAttachmentsForIndex:index];
    }
}

#pragma mark - Lazy Load

- (NSMutableArray<SCMBResource *> *)internalResources {
    if (!_internalResources) {
        _internalResources = [NSMutableArray array];
    }
    return _internalResources;
}

- (SCMBCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[SCMBCollectionView alloc] initWithFrame:self.bounds];
        _collectionView.scmbDelegate = self;
    }
    return _collectionView;
}

@end
