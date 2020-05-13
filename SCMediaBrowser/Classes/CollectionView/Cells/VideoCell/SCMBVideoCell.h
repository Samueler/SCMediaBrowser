//
//  SCMBVideoCell.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import <UIKit/UIKit.h>
#import "SCMBVideoResource.h"

@interface SCMBVideoCell : UICollectionViewCell

@property (nonatomic, strong) SCMBVideoResource *resource;

@property (nonatomic, strong, readonly) UIImageView *coverImageView;

@end
