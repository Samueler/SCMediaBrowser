//
//  SCMBViewController.m
//  SCMediaBrowser
//
//  Created by ty.Chen on 05/11/2020.
//  Copyright (c) 2020 samueler.chen@gmail.com. All rights reserved.
//

#import "SCMBViewController.h"
#import "SCMediaBrowser.h"
#import "SCMBTestCell.h"
#import <UIImageView+WebCache.h>

static NSString *const kSCMBTestCellKey = @"kSCMBTestCellKey";

@interface SCMBViewController () <
SCMBDataSource,
SCMBDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *thumbnailImageViews;
@property (nonatomic, strong) NSMutableArray<SCMBResource *> *resources;

@end

@implementation SCMBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int idx = 0; idx < 4; idx++) {
        SCMBImageResource *resource = [[SCMBImageResource alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"IMG_207%d", idx]]];
        [self.resources addObject:resource];
    }
    
    SCMBVideoResource *videoResource = [[SCMBVideoResource alloc] initWithURL:[NSURL URLWithString:@"https://mvvideo5.meitudata.com/56ea0e90d6cb2653.mp4"] loopCount:2];
    videoResource.attachment.originSize = CGSizeMake(854, 480);
    [self.resources addObject:videoResource];
    
    SCMBImageResource *gifResource = [[SCMBImageResource alloc] initWithURL:[NSURL URLWithString:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1708456121,4044353785&fm=26&gp=0.jpg"]];
    [self.resources addObject:gifResource];
    
    SCMBVideoResource *videoResource1 = [[SCMBVideoResource alloc] initWithURL:[NSURL URLWithString:@"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.mp4"] loopCount:0];
    videoResource1.attachment.originSize = CGSizeMake(540, 960);
    [self.resources addObject:videoResource1];
    
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfResourcesInMediaBrowser:(SCMediaBrowser *)mediaBrowser {
    return self.resources.count;
}

- (SCMBResource *)mediaBrowser:(SCMediaBrowser *)mediaBrowser resourceAtIndex:(NSInteger)index {
    return self.resources[index];
}

- (UIImageView *)mediaBrowser:(SCMediaBrowser *)mediaBrowser thumbnailViewAtIndex:(NSInteger)index {
    return self.thumbnailImageViews[index];
}

- (void)mediaBrowser:(SCMediaBrowser *)mediaBrowser displayingResource:(SCMBResource *)resource forItemAtIndex:(NSInteger)currentIndex {
    NSLog(@"currentIndex: %zd", mediaBrowser.currentIndex);
}

- (void)mediaBrowser:(SCMediaBrowser *)mediaBrowser resource:(SCMBResource *)resource downloadProgress:(float)progress {
    NSLog(@"progress: %f", progress);
}

- (BOOL)mediaBrowser:(SCMediaBrowser *)mediaBrowser containerView:(UIView *)containerView contentView:(UIView *)contentView customAttachmentsForIndex:(NSInteger)index {
    if (index == 2) {
        UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        greenView.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 100, 80)];
        label.text = @"哈哈哈";
        label.backgroundColor = [UIColor orangeColor];
        [greenView addSubview:label];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 120, 100, 80)];
        btn.backgroundColor = [UIColor purpleColor];
        [btn setTitle:@"这是一个按钮" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [greenView addSubview:btn];
        
        [containerView addSubview:greenView];
        return YES;
    } else if (index == 4) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 44)];
        label.text = [NSString stringWithFormat:@"视频上的label：%zd", index];
        label.backgroundColor = [UIColor orangeColor];
        [containerView addSubview:label];
        return YES;
    } else if (index == 6) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 44)];
        label.text = [NSString stringWithFormat:@"视频上的label：%zd", index];
        label.backgroundColor = [UIColor orangeColor];
        [containerView addSubview:label];
        return YES;
    }
    return NO;
}

- (void)btnClick {
    NSLog(@"---btnClick---");
}

- (void)mediaBrowser:(SCMediaBrowser *)mediaBrowser currentStatusChanged:(SCAVPlayerStatus)status index:(NSInteger)index {
    NSLog(@"status: %lu", (unsigned long)status);
}

- (void)mediaBrowser:(SCMediaBrowser *)mediaBrowser currentDuration:(NSTimeInterval)currentDuration totalDuration:(NSTimeInterval)totalDuration index:(NSInteger)index {
    NSLog(@"currentDuration:%f, totalDuration:%f", currentDuration, totalDuration);
}

- (void)mediaBrowser:(SCMediaBrowser *)mediaBrowser bufferedDuration:(NSTimeInterval)bufferedDuration index:(NSInteger)index {
    NSLog(@"bufferedDuration: %f", bufferedDuration);
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resources.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCMBTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSCMBTestCellKey forIndexPath:indexPath];
    
    SCMBResource *resource = self.resources[indexPath.item];
    if ([resource isKindOfClass:[SCMBImageResource class]]) {
        
        SCMBImageResource *imageResource = (SCMBImageResource *)resource;
        if (imageResource.image) {
            cell.contentImgView.image = imageResource.image;
        } else {
            [cell.contentImgView sd_setImageWithURL:imageResource.URL];
        }
    } else {
        [cell.contentImgView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1589368632597&di=5bd8b849c54cb387e558dd8afb4ca8c2&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%3D580%2Fsign%3D24e63ea01530e924cfa49c397c096e66%2F1aca061fbe096b63d5ca7df806338744e9f8acd7.jpg"]];
    }
    
    if (![self.thumbnailImageViews containsObject:cell.contentImgView]) {
        [self.thumbnailImageViews addObject:cell.contentImgView];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SCMediaBrowser *browser = [[SCMediaBrowser alloc] initWithIndex:indexPath.item];
    browser.dataSource = self;
    browser.delegate = self;
    [browser presentMediaBrowser];
}

#pragma mark - Lazy Load

- (NSMutableArray<SCMBResource *> *)resources {
    if (!_resources) {
        _resources = [NSMutableArray array];
    }
    return _resources;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 10;
        _layout.minimumInteritemSpacing = 0;
        _layout.itemSize = CGSizeMake(100, 100);
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor orangeColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[SCMBTestCell class] forCellWithReuseIdentifier:kSCMBTestCellKey];
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

- (NSMutableArray *)thumbnailImageViews {
    if (!_thumbnailImageViews) {
        _thumbnailImageViews = [NSMutableArray array];
    }
    return _thumbnailImageViews;;
}


@end
