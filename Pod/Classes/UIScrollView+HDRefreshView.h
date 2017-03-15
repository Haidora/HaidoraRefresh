//
//  UIScrollView+HDRefreshView.h
//  Pods
//
//  Created by Dailingchi on 15/4/16.
//
//

#import <UIKit/UIKit.h>
#import "HaidoraRefreshDefine.h"

@class HDPullToRefreshView;
@class HDInfiniteToRefreshView;

@interface UIScrollView (HDPullRefreshView)

@property (nonatomic, strong, readonly) HDPullToRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL showPullRefreshView;

#pragma mark
#pragma mark Pull to Refresh
- (void)addPullToRefreshWithActionHandler:(HDRefreshBlock)actionHandler;
- (void)addPullToRefreshWithActionHandler:(HDRefreshBlock)actionHandler
                                 animator:(id<HaidoraRefreshAnimator>)animator;
- (void)triggerPullToRefresh;
- (void)stopPullRefresh;

@end

@interface UIScrollView (HDInfiniteRefreshView)

@property (nonatomic, strong, readonly) HDInfiniteToRefreshView *infiniteToRefreshView;
@property (nonatomic, assign) BOOL showInfiniteRefreshView;
/**
 The validity of 
 `self.infiniteToRefreshView.alpha = (self.frame.size.height > self.contentSize.height) ? 0 : 1`
 
 default is YES.
 */
@property (nonatomic, assign) BOOL infiniteRefreshViewAutoHidden;

#pragma mark
#pragma mark Infinite to Refresh
- (void)addInfiniteToRefreshWithActionHandler:(HDRefreshBlock)actionHandler;
- (void)addInfiniteToRefreshWithActionHandler:(HDRefreshBlock)actionHandler
                                     animator:(id<HaidoraRefreshAnimator>)animator;
- (void)triggerInfiniteToRefresh;
- (void)stopInfiniteRefresh;

@end