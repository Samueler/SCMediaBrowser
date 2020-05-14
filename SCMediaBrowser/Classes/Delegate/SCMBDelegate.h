//
//  SCMBDelegate.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import <Foundation/Foundation.h>
#import "SCAVSinglePlayer.h"

@class SCMediaBrowser, SCMBResource, SCMBVideoResource;

@protocol SCMBDelegate <NSObject>

@optional

- (void)mediaBrowser:(SCMediaBrowser *)mediaBrowser displayingResource:(SCMBResource *)resource forItemAtIndex:(NSInteger)currentIndex;

- (void)mediaBrowser:(SCMediaBrowser *)mediaBrowser resource:(SCMBResource *)resource downloadProgress:(float)progress;

- (void)mediaBrowser:(SCMediaBrowser *)mediaBrowser currentDuration:(NSTimeInterval)currentDuration totalDuration:(NSTimeInterval)totalDuration index:(NSInteger)index;

- (void)mediaBrowser:(SCMediaBrowser *)mediaBrowser bufferedDuration:(NSTimeInterval)bufferedDuration index:(NSInteger)index;

- (void)mediaBrowser:(SCMediaBrowser *)mediaBrowser currentStatusChanged:(SCAVPlayerStatus)status index:(NSInteger)index;

@end
