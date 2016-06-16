//
//  HaidoraRefreshDefine.h
//  Pods
//
//  Created by Dailingchi on 15/4/14.
//
//

#ifndef Pods_HaidoraRefreshDefine_h
#define Pods_HaidoraRefreshDefine_h

#define HDRefreshViewContentOffSetKeyPath @"contentOffset"
#define HDRefreshViewContentSizeKeyPath @"contentSize"

typedef void (^HDRefreshBlock)(void);

static CGFloat HDRefreshDefaultHeight = 55.0;
static NSString *HDRefreshBundleName = @"HaidoraRefresh";

static NSString *HDPullTORefreshKVOContext = @"HDPullTORefreshKVOContext";
static NSString *HDInfiniteToRefreshKVOContext = @"HDInfiniteToRefreshKVOContext";

typedef NS_ENUM(NSInteger, HDRefreshViewPosition) {
    HDRefreshViewPositionTop = 0,
    HDRefreshViewPositionBottom
};

@protocol HaidoraRefreshAnimator <NSObject>

@required

@property (nonatomic, assign) HDRefreshViewPosition position;

- (void)startLoadingAnimation;
- (void)stopLoadingAnimation;
// when progress > 1 is release state
- (void)changeProgress:(CGFloat)progress;
// add custom sub view
- (void)layoutSubviewsWith:(UIView *)superView;

@end

#endif
