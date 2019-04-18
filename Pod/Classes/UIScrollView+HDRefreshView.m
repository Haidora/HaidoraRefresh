//
//  UIScrollView+HDRefreshView.m
//  Pods
//
//  Created by Dailingchi on 15/4/16.
//
//

#import "HDInfiniteToRefreshView.h"
#import "HDPullToRefreshView.h"
#import "HDRefreshAnimator.h"
#import "UIScrollView+HDRefreshPrivate.h"
#import "UIScrollView+HDRefreshView.h"
#import <objc/runtime.h>

static char *kHaidoraPullToRefreshView = "kHaidoraPullToRefreshView";

@implementation UIScrollView (HDPullRefreshView)

@dynamic showPullRefreshView;
@dynamic pullToRefreshView;

#pragma mark
#pragma mark Action

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
        self.showPullRefreshView = YES;
    }
}

- (void)triggerPullToRefresh
{
    if (!self.pullRefreshLoading)
    {
        [self.pullToRefreshView startAnimating];
    }
}

- (void)stopPullRefresh
{
    if (self.pullRefreshLoading)
    {
        [self.pullToRefreshView stopAnimating];
    }
}

#pragma mark
#pragma mark Getter/Setter

- (void)setPullToRefreshView:(HDPullToRefreshView *)pullToRefreshView
{
    objc_setAssociatedObject(self, kHaidoraPullToRefreshView, pullToRefreshView,
                             OBJC_ASSOCIATION_RETAIN);
}

- (HDPullToRefreshView *)pullToRefreshView
{
    return objc_getAssociatedObject(self, kHaidoraPullToRefreshView);
}

- (void)setShowPullRefreshView:(BOOL)showPullRefreshView
{
    self.pullToRefreshView.hidden = showPullRefreshView;
    if (!showPullRefreshView)
    {
        if (self.pullToRefreshView.isObserving)
        {
            [self removeObserver:self.pullToRefreshView
                      forKeyPath:HDRefreshViewContentOffSetKeyPath];
            self.pullToRefreshView.isObserving = NO;
        }
    }
    else
    {
        if (!self.pullToRefreshView.isObserving)
        {
            [self addObserver:self.pullToRefreshView
                   forKeyPath:HDRefreshViewContentOffSetKeyPath
                      options:NSKeyValueObservingOptionNew
                      context:(__bridge void *_Nullable)(HDPullTORefreshKVOContext)];
            self.pullToRefreshView.isObserving = YES;
        }
    }
}

- (BOOL)showPullRefreshView
{
    return !self.pullToRefreshView.hidden;
}

@end

static char *kHaidoraInfiniteToRefreshView = "kHaidoraInfiniteToRefreshView";
static char *kHaidoraInfiniteRefreshViewAutoHidden = "kHaidoraInfiniteRefreshViewAutoHidden";

@implementation UIScrollView (HDInfiniteRefreshView)

@dynamic infiniteToRefreshView;
@dynamic showInfiniteRefreshView;

#pragma mark
#pragma mark Action

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
        self.infiniteRefreshViewAutoHidden = YES;
        self.infiniteToRefreshView = refreshView;
        self.infiniteToRefreshView.animator = animator;
        self.infiniteToRefreshView.action = actionHandler;
        [self addSubview:self.infiniteToRefreshView];
        self.showInfiniteRefreshView = YES;
    }
}

- (void)triggerInfiniteToRefresh
{
    if (!self.infiniteRefreshLoading)
    {
        [self.infiniteToRefreshView startAnimating];
    }
}

- (void)stopInfiniteRefresh
{
    if (self.infiniteRefreshLoading)
    {
        [self.infiniteToRefreshView stopAnimating];
    }
}

#pragma mark
#pragma mark Getter/Setter

- (void)setInfiniteRefreshViewAutoHidden:(BOOL)infiniteRefreshViewAutoHidden
{
    objc_setAssociatedObject(self, kHaidoraInfiniteRefreshViewAutoHidden, @(infiniteRefreshViewAutoHidden),
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)infiniteRefreshViewAutoHidden
{
    return [objc_getAssociatedObject(self, kHaidoraInfiniteRefreshViewAutoHidden) boolValue];
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

- (void)setShowInfiniteRefreshView:(BOOL)showInfiniteRefreshView
{
    self.infiniteToRefreshView.hidden = !showInfiniteRefreshView;
    if (!showInfiniteRefreshView)
    {
        if (self.infiniteToRefreshView.isObserving)
        {
            [self removeObserver:self.infiniteToRefreshView
                      forKeyPath:HDRefreshViewContentOffSetKeyPath
                         context:(__bridge void *_Nullable)(HDInfiniteToRefreshKVOContext)];
            [self removeObserver:self.infiniteToRefreshView
                      forKeyPath:HDRefreshViewContentSizeKeyPath
                         context:(__bridge void *_Nullable)(HDInfiniteToRefreshKVOContext)];
            self.infiniteToRefreshView.isObserving = NO;
        }
    }
    else
    {
        if (!self.infiniteToRefreshView.isObserving)
        {
            [self addObserver:self.infiniteToRefreshView
                   forKeyPath:HDRefreshViewContentOffSetKeyPath
                      options:NSKeyValueObservingOptionInitial
                      context:(__bridge void *_Nullable)(HDInfiniteToRefreshKVOContext)];
            [self addObserver:self.infiniteToRefreshView
                   forKeyPath:HDRefreshViewContentSizeKeyPath
                      options:NSKeyValueObservingOptionInitial
                      context:(__bridge void *_Nullable)(HDInfiniteToRefreshKVOContext)];
            self.infiniteToRefreshView.isObserving = YES;
        }
    }
}

- (BOOL)showInfiniteRefreshView
{
    return !self.infiniteToRefreshView.hidden;
}

@end
