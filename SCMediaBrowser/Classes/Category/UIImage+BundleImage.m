//
//  UIImage+BundleImage.m
//  SCMediaBrowser
//
//  Created by 妈妈网 on 2020/5/13.
//

#import "UIImage+BundleImage.h"
#import "SCMediaBrowser.h"

static NSString * const kResourceBundleName = @"SCMediaBrowser.bundle";

@implementation UIImage (BundleImage)

+ (UIImage *)bundleImageNamed:(NSString *)imageName {
    NSBundle *bundle = [NSBundle bundleForClass:[SCMediaBrowser class]];
    NSString *component = [kResourceBundleName stringByAppendingPathComponent:imageName];
    return [UIImage imageNamed:component inBundle:bundle compatibleWithTraitCollection:nil];
}

@end
