//
//  ZoomManager.h
//  PanTest
//
//  Created by Cédric Foucault on 07/12/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomManager : NSObject

+ (id)sharedManager;

- (void)setScrollView:(UIScrollView *)scrollView;
- (CGFloat)zoomScale;

@end
