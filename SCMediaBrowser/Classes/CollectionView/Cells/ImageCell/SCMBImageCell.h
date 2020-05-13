//
//  SCMBImageCell.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import <UIKit/UIKit.h>
#import "SCMBImageResource.h"

@interface SCMBImageCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIView *imageContentView;
@property (nonatomic, strong) SCMBImageResource *resource;

@end
