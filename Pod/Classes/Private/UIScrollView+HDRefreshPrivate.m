//
//  UIScrollView+HDRefreshPrivate.m
//  Pods
//
//  Created by Dailingchi on 15/8/7.
//
//

#import "UIScrollView+HDRefreshPrivate.h"
#import <objc/runtime.h>
#import "HaidoraRefreshDefine.h"

static char *kHaidoraPullRefreshLoading = "kHaidoraPullRefreshLoading";
static char *kHaidoraInfiniteTRefreshLoading = "kHaidoraInfiniteTRefreshLoading";

@implementation UIScrollView (HDRefreshPrivate)

@dynamic pullRefreshLoading;
@dynamic infiniteRefreshLoading;

- (void)setPullRefreshLoading:(BOOL)pullRefreshLoading
{
    objc_setAssociatedObject(self, kHaidoraPullRefreshLoading, @(pullRefreshLoading),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)pullRefreshLoading
{
    return [objc_getAssociatedObject(self, kHaidoraPullRefreshLoading) boolValue];
}

- (void)setInfiniteRefreshLoading:(BOOL)infiniteRefreshLoading
{
    objc_setAssociatedObject(self, kHaidoraInfiniteTRefreshLoading, @(infiniteRefreshLoading),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)infiniteRefreshLoading
{
    return [objc_getAssociatedObject(self, kHaidoraInfiniteTRefreshLoading) boolValue];
}

@end

static char *kHDRefreshPrivateisObserving = "kHDRefreshPrivateisObserving";
@implementation UIView (HDRefreshPrivate)

@dynamic isObserving;

- (void)setIsObserving:(BOOL)isObserving
{
    objc_setAssociatedObject(self, kHDRefreshPrivateisObserving, @(isObserving),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isObserving
{
    return [objc_getAssociatedObject(self, kHDRefreshPrivateisObserving) boolValue];
}

@end
