//
//  SCMBDataSource.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import <Foundation/Foundation.h>

@class SCMediaBrowser, SCMBResource;

@protocol SCMBDataSource <NSObject>

- (NSInteger)numberOfResourcesInMediaBrowser:(SCMediaBrowser *)mediaBrowser;

- (SCMBResource *)mediaBrowser:(SCMediaBrowser *)mediaBrowser resourceAtIndex:(NSInteger)index;

@optional

- (BOOL)mediaBrowser:(SCMediaBrowser *)mediaBrowser containerView:(UIView *)containerView contentView:(UIView *)contentView customAttachmentsForIndex:(NSInteger)index;

- (UIImageView *)mediaBrowser:(SCMediaBrowser *)mediaBrowser thumbnailViewAtIndex:(NSInteger)index;

@end
