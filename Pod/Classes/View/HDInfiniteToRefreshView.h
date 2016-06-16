//
//  HDInfiniteToRefreshView.h
//  Pods
//
//  Created by Dailingchi on 15/4/15.
//
//

#import <UIKit/UIKit.h>
#import "HaidoraRefreshDefine.h"

@interface HDInfiniteToRefreshView : UIView

@property (nonatomic, strong) id<HaidoraRefreshAnimator> animator;
@property (nonatomic, copy) HDRefreshBlock action;

#pragma mark
#pragma mark Action
- (void)startAnimating;
- (void)stopAnimating;

@end
