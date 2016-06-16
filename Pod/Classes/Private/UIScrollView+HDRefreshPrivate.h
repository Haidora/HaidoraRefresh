//
//  UIScrollView+HDRefreshPrivate.h
//  Pods
//
//  Created by Dailingchi on 15/8/7.
//
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HDRefreshPrivate)

@property (nonatomic, assign) BOOL pullRefreshLoading;
@property (nonatomic, assign) BOOL infiniteRefreshLoading;

@end

@interface UIView (HDRefreshPrivate)

@property (nonatomic, assign) BOOL isObserving;

@end