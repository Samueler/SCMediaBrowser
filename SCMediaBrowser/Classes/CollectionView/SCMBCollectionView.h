//
//  SCMBCollectionView.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import <UIKit/UIKit.h>
#import "SCMBResource.h"

@class SCMBCollectionView, SCMBImageScrollView, SDAnimatedImageView;

@protocol SCMBCollectionViewDelegate <NSObject>

- (void)collectionView:(SCMBCollectionView *)collectionView containerView:(UIView *)containerView contentView:(UIView *)contentView cellForItemAtIndex:(NSInteger)index;

@end

@interface SCMBCollectionView : UICollectionView

@property (nonatomic, strong) NSArray<SCMBResource *> *resources;
@property (nonatomic, weak) id<SCMBCollectionViewDelegate> scmbDelegate;

@end
