//
//  HaidoraRefreshDefine.h
//  Pods
//
//  Created by Dailingchi on 15/4/14.
//
//

#ifndef Pods_HaidoraRefreshDefine_h
#define Pods_HaidoraRefreshDefine_h

typedef void (^HDRefreshBlock)(void);
static CGFloat HaidoraPullToRefreshDefaultHeight = 55.0;
#define HDRefreshViewContentOffSetKeyPath @"contentOffset"
#define HDRefreshViewContentSizeKeyPath @"contentSize"

//刷新动画相关协议
@protocol HaidoraRefreshAnimator <NSObject>

@required

- (void)startLoadingAnimation;
- (void)stopLoadingAnimation;
// when progress > 1 is release state
- (void)changeProgress:(CGFloat)progress;
// add custom view
- (void)layoutSubviewsWith:(UIView *)superView;

@end

#endif
