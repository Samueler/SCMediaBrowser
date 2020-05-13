//
//  SCMBEventProxy.h
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCEventProxy.h"
#import "SCMediaBrowser.h"

@interface SCMBEventProxy : SCEventProxy

@property (nonatomic, weak) SCMediaBrowser *browser;

@end
