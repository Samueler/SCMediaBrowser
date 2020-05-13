//
//  SCMBCollectionView.m
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMBCollectionView.h"
#import "SCMBFlowLayout.h"
#import "SCMBImageCell.h"
#import "SCMBVideoCell.h"
#import "SCMBImageResource.h"
#import "SCMBVideoResource.h"
#import "UIResponder+SCRouter.h"

static NSString *const SCMBImageCellReuseIdentifier = @"SCMBImageCellReuseIdentifier";
static NSString *const SCMBVideoCellReuseIdentifier = @"SCMBVideoCellReuseIdentifier";

NSString *const kSCMBDisplayingIndexChangedAction = @"kSCMBDisplayingIndexChangedAction";

@interface SCMBCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) SCMBFlowLayout *layout;
@property (nonatomic, assign) NSInteger displayingIndex;
@property (nonatomic, strong) SCMBAVPlayer *avPlayer;

@end

@implementation SCMBCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame collectionViewLayout:self.layout];;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Private Functions

- (void)commonInit {
    self.delegate = self;
    self.dataSource = self;
    self.pagingEnabled = YES;
    self.alwaysBounceVertical = NO;
    self.alwaysBounceHorizontal = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self registerClass:[SCMBImageCell class] forCellWithReuseIdentifier:SCMBImageCellReuseIdentifier];
    [self registerClass:[SCMBVideoCell class] forCellWithReuseIdentifier:SCMBVideoCellReuseIdentifier];
}

- (void)shouldHideAttachmentViewForCell:(UICollectionViewCell *)cell {
    for (UIView *subView in cell.subviews) {
        if ([subView.accessibilityIdentifier isEqualToString:kSCMBAttachmentViewIdentifier] ) {
            subView.hidden = YES;
        }
    }
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCMBResource *resource = self.resources[indexPath.item];
    
    [self.avPlayer pause];
    
    if ([resource isKindOfClass:[SCMBImageResource class]]) {
        SCMBImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SCMBImageCellReuseIdentifier forIndexPath:indexPath];
        
        if (self.scmbDelegate && [self.scmbDelegate respondsToSelector:@selector(collectionView:containerView:contentView:cellForItemAtIndex:)]) {
            [self.scmbDelegate collectionView:self containerView:cell contentView:cell.imageContentView cellForItemAtIndex:indexPath.item];
        }
        
        cell.resource = (SCMBImageResource *)resource;
        
        return cell;
    }
    
    SCMBVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SCMBVideoCellReuseIdentifier forIndexPath:indexPath];
    
    cell.resource = (SCMBVideoResource *)resource;
    
    self.avPlayer = cell.avPlayer;
    [self.avPlayer play];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float value = self.contentOffset.x / self.layout.itemSize.width;
    NSInteger currentIndex = value;
    
    SCMBResource *resource = self.resources[currentIndex];
    resource.attachment.panGestureEnable = value == currentIndex;
    
    if (self.displayingIndex != currentIndex) {
        [self routerEventForName:kSCMBDisplayingIndexChangedAction paramaters:@[self, resource, @(currentIndex)]];
        self.displayingIndex = currentIndex;
    }
}

#pragma mark - Setter

- (void)setResources:(NSArray<SCMBResource *> *)resources {
    _resources = resources;
    
    [self reloadData];
}

#pragma mark - Lazy Load

- (SCMBFlowLayout *)layout {
    if (!_layout) {
        _layout = [[SCMBFlowLayout alloc] init];
    }
    return _layout;
}

- (void)dealloc {
    [self.avPlayer pause];
}

@end
