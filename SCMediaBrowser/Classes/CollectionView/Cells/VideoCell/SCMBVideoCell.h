//
//  SCMBVideoCell.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import <UIKit/UIKit.h>
#import "SCAVSinglePlayer.h"
#import "SCMBVideoResource.h"

@interface SCMBVideoCell : UICollectionViewCell

@property (nonatomic, strong, readonly) SCAVSinglePlayer *avPlayer;
@property (nonatomic, strong, readonly) UIView *videoContainView;

@property (nonatomic, strong) SCMBVideoResource *resource;

@end
