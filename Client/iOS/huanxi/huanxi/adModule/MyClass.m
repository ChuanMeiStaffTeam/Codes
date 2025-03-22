//
//  MyClass.m
//  TestDemo
//
//  Created by ByteDance on 2025/3/21.
//

#import "MyClass.h"


@implementation MyClass

- (UIWindow *)mainWindow
{
    UIWindow *window = nil;
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        window = [[UIApplication sharedApplication].delegate window];
    }
    if (![window isKindOfClass:[UIView class]]) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}

@end
