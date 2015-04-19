//
//  UIScrollView+HDRefreshView.h
//  Pods
//
//  Created by Dailingchi on 15/4/16.
//
//

#import <UIKit/UIKit.h>
#import "HDPullToRefreshView.h"
#import "HDInfiniteToRefreshView.h"

@interface UIScrollView (HDRefreshView)

@property (nonatomic, assign) BOOL refreshLoading;

@property (nonatomic, strong, readonly) HDPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong, readonly) HDInfiniteToRefreshView *infiniteToRefreshView;

#pragma mark
#pragma mark Pull to Refresh
- (void)addPullToRefreshWithActionHandler:(HDRefreshBlock)actionHandler;
- (void)addPullToRefreshWithActionHandler:(HDRefreshBlock)actionHandler
                                 animator:(id<HaidoraRefreshAnimator>)animator;
- (void)triggerPullToRefresh;
- (void)stopPullRefresh;

#pragma mark
#pragma mark Infinite to Refresh
- (void)addInfiniteToRefreshWithActionHandler:(HDRefreshBlock)actionHandler;
- (void)addInfiniteToRefreshWithActionHandler:(HDRefreshBlock)actionHandler
                                     animator:(id<HaidoraRefreshAnimator>)animator;
- (void)triggerInfiniteToRefresh;
- (void)stopInfiniteRefresh;

@end
