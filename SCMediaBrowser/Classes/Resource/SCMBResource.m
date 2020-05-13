//
//  SCMBResource.m
//  SCMediaBrowser
//
//  Created by ty.Chen on 2020/5/11.
//

#import "SCMBResource.h"

@implementation SCMBResource

- (instancetype)init {
    if (self = [super init]) {
        _attachment = [[SCMBResourceAttachment alloc] init];
    }
    return self;
}

@end
