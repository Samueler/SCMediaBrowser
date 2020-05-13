//
//  SCMBResource.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import <Foundation/Foundation.h>
#import "SCMBResourceAttachment.h"

extern NSString *const kSCMBResourceDownloadProgressAction;
extern NSString *const kSCMBResourcePropertyStringForDownloadProgress;

@interface SCMBResource : NSObject

@property (nonatomic, assign, readonly) float downloadProgress;

@property (nonatomic, strong) SCMBResourceAttachment *attachment;

@end
