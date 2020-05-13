//
//  SCMBImageScrollView.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import <UIKit/UIKit.h>
#import "SDAnimatedImageView.h"

@interface SCMBImageScrollView : UIScrollView

@property (nonatomic, strong, readonly) SDAnimatedImageView *contentImgView;

@end
