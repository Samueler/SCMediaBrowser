//
//  SCMBResourceAttachment.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import <Foundation/Foundation.h>

extern NSString *const kSCMBAttachmentViewIdentifier;

@interface SCMBResourceAttachment : NSObject

@property (nonatomic, assign) CGSize originSize;
@property (nonatomic, strong) UIView *originContentView;
@property (nonatomic, assign) CGSize thumbnailSize;
@property (nonatomic, strong) UIView *thumbnailContentView;
@property (nonatomic, assign) BOOL panGestureEnable;
@property (nonatomic, assign) BOOL addedAttachmentView;

@end
