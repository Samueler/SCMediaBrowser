//
//  SCMediaBrowser.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import <UIKit/UIKit.h>
#import "SCMBResource.h"
#import "SCMBDelegate.h"
#import "SCMBDataSource.h"
#import "SCMBImageResource.h"
#import "SCMBVideoResource.h"

@interface SCMediaBrowser : UIView

@property (nonatomic, weak) id<SCMBDelegate> delegate;
@property (nonatomic, weak) id<SCMBDataSource> dataSource;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, strong, readonly) SCMBResource *currentResource;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithIndex:(NSInteger)index;

+ (instancetype)mediaBrowserWithIndex:(NSInteger)index;

- (void)reloadData;

- (void)presentMediaBrowser;

- (void)dismissMediaBrowser;

@end
