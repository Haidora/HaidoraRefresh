//
//  UIScrollView+HDRefreshView.m
//  Pods
//
//  Created by Dailingchi on 15/4/16.
//
//

#import "UIScrollView+HDRefreshView.h"
#import <objc/runtime.h>
#import "HaidoraRefreshDefine.h"
#import "HDRefreshAnimator.h"

static char *kHaidoraRefreshLoading = "kHaidoraRefreshLoading";
static char *kHaidoraPullToRefreshView = "kHaidoraPullToRefreshView";
static char *kHaidoraInfiniteToRefreshView = "kHaidoraInfiniteToRefreshView";

@implementation UIScrollView (HDRefreshView)

@dynamic refreshLoading;
@dynamic pullToRefreshView;
@dynamic infiniteToRefreshView;

- (void)setRefreshLoading:(BOOL)refreshLoading
{
    objc_setAssociatedObject(self, kHaidoraRefreshLoading, @(refreshLoading),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)refreshLoading
{
    return [objc_getAssociatedObject(self, kHaidoraRefreshLoading) boolValue];
}

- (void)setPullToRefreshView:(HDPullToRefreshView *)pullToRefreshView
{
    objc_setAssociatedObject(self, kHaidoraPullToRefreshView, pullToRefreshView,
                             OBJC_ASSOCIATION_RETAIN);
}

- (HDPullToRefreshView *)pullToRefreshView
{
    return objc_getAssociatedObject(self, kHaidoraPullToRefreshView);
}

- (void)setInfiniteToRefreshView:(HDInfiniteToRefreshView *)infiniteToRefreshView
{
    objc_setAssociatedObject(self, kHaidoraInfiniteToRefreshView, infiniteToRefreshView,
                             OBJC_ASSOCIATION_RETAIN);
}

- (HDInfiniteToRefreshView *)infiniteToRefreshView
{
    return objc_getAssociatedObject(self, kHaidoraInfiniteToRefreshView);
}

- (void)addPullToRefreshWithActionHandler:(HDRefreshBlock)actionHandler
{
    HDClassicAnimator *animator = [[HDClassicAnimator alloc] init];
    [self addPullToRefreshWithActionHandler:actionHandler animator:animator];
}

- (void)addPullToRefreshWithActionHandler:(HDRefreshBlock)actionHandler
                                 animator:(id<HaidoraRefreshAnimator>)animator
{
    HDPullToRefreshView *refresh = [[HDPullToRefreshView alloc]
        initWithFrame:CGRectMake(0, -HDRefreshDefaultHeight, CGRectGetWidth(self.bounds),
                                 HDRefreshDefaultHeight)];
    [animator setPosition:HDRefreshViewPositionTop];
    [self addPullToRefreshWithActionHandler:actionHandler animator:animator refreshView:refresh];
}

- (void)addPullToRefreshWithActionHandler:(HDRefreshBlock)actionHandler
                                 animator:(id<HaidoraRefreshAnimator>)animator
                              refreshView:(HDPullToRefreshView *)refreshView
{
    if (self.pullToRefreshView == nil)
    {
        self.pullToRefreshView = refreshView;
        self.pullToRefreshView.animator = animator;
        self.pullToRefreshView.action = actionHandler;
        [self addSubview:self.pullToRefreshView];
    }
}

- (void)triggerPullToRefresh
{
    if (!self.refreshLoading)
    {
        [self.pullToRefreshView startAnimating];
    }
}

- (void)stopPullRefresh
{
    if (self.refreshLoading)
    {
        [self.pullToRefreshView stopAnimating];
    }
}

- (void)addInfiniteToRefreshWithActionHandler:(HDRefreshBlock)actionHandler
{
    HDClassicAnimator *animator = [[HDClassicAnimator alloc] init];
    [self addInfiniteToRefreshWithActionHandler:actionHandler animator:animator];
}

- (void)addInfiniteToRefreshWithActionHandler:(HDRefreshBlock)actionHandler
                                     animator:(id<HaidoraRefreshAnimator>)animator
{
    HDInfiniteToRefreshView *refresh = [[HDInfiniteToRefreshView alloc]
        initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds),
                                 HDRefreshDefaultHeight)];
    [animator setPosition:HDRefreshViewPositionBottom];
    [self addInfiniteToRefreshWithActionHandler:actionHandler
                                       animator:animator
                                    refreshView:refresh];
}

- (void)addInfiniteToRefreshWithActionHandler:(HDRefreshBlock)actionHandler
                                     animator:(id<HaidoraRefreshAnimator>)animator
                                  refreshView:(HDInfiniteToRefreshView *)refreshView
{
    if (self.infiniteToRefreshView == nil)
    {
        self.infiniteToRefreshView = refreshView;

        self.infiniteToRefreshView.animator = animator;
        self.infiniteToRefreshView.action = actionHandler;
        [self addSubview:self.infiniteToRefreshView];
    }
}

- (void)triggerInfiniteToRefresh
{
    if (!self.refreshLoading)
    {
        [self.infiniteToRefreshView startAnimating];
    }
}

- (void)stopInfiniteRefresh
{
    if (self.refreshLoading)
    {
        [self.infiniteToRefreshView stopAnimating];
    }
}

@end
