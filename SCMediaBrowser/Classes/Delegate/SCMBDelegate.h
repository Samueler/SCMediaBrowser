//
//  SCMBDelegate.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import <Foundation/Foundation.h>

@class SCMediaBrowser, SCMBResource;

@protocol SCMBDelegate <NSObject>

@optional

- (void)mediaBrowser:(SCMediaBrowser *)mediaBrowser displayingResource:(SCMBResource *)resource forItemAtIndex:(NSInteger)currentIndex;

- (void)mediaBrowser:(SCMediaBrowser *)mediaBrowser resource:(SCMBResource *)resource downloadProgress:(float)progress;

@end
