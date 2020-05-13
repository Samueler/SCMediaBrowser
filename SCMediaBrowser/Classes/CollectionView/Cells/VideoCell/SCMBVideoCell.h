//
//  SCMBVideoCell.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import <UIKit/UIKit.h>
#import "SCMBAVPlayer.h"
#import "SCMBVideoResource.h"

@interface SCMBVideoCell : UICollectionViewCell

@property (nonatomic, strong, readonly) SCMBAVPlayer *avPlayer;
@property (nonatomic, strong, readonly) UIView *videoContainView;

@property (nonatomic, strong) SCMBVideoResource *resource;

@end
