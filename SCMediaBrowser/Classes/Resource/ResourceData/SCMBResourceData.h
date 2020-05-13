//
//  SCMBResourceData.h
//  SCMediaBrowser
//
//  Created by 妈妈网 on 2020/5/13.
//

#import <Foundation/Foundation.h>

@protocol SCMBResourceData <NSObject>

@property (nonatomic, strong, readonly) NSURL *URL;
@property (nonatomic, strong, readonly) UIImage *placeholder;

- (instancetype)initWithURL:(NSURL *)URL;

@end
