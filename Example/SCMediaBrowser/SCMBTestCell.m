//
//  SCMBTestCell.m
//  SCMediaBrowser
//
//  Created by 妈妈网 on 2020/5/9.
//  Copyright © 2020 ty.Chen. All rights reserved.
//

#import "SCMBTestCell.h"

@implementation SCMBTestCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentImgView = [[SDAnimatedImageView alloc] init];
        [self addSubview:self.contentImgView];
        self.contentImgView.frame = self.bounds;
        
        self.contentImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.contentImgView.clipsToBounds = YES;
    }
    return self;
}

@end
