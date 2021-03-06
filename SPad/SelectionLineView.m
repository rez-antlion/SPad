//
//  SelectionLineView.m
//  SPad
//
//  Created by Cédric Foucault on 24/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "SelectionLineView.h"
#import "UIView+LayoutConstraints.h"
#import "ZoomManager.h"

static const CGFloat SELECTION_LINE_WIDTH = 4;

@interface SelectionLineView ()

@property (strong, nonatomic) UIBezierPath *selectionLine;
@property (strong, nonatomic) UIColor *selectionLineColor;
@property CGFloat selectionLineWidth;

@end

@implementation SelectionLineView

- (id)initWithFrame:(CGRect)frame {
    CGRect framePadded = frame;
    framePadded.size.width += SELECTION_LINE_WIDTH;
    framePadded.size.height += SELECTION_LINE_WIDTH;
    self = [super initWithFrame:framePadded];
    if (self) {
        // init selection line
        _selectionLine = [[UIBezierPath alloc] init];
        _selectionLineWidth = SELECTION_LINE_WIDTH;
        _selectionLineColor = [UIColor colorWithRed:1.0 green:0.8 blue:0 alpha:1];
        _selectionLine.lineWidth = self.selectionLineWidth / [[ZoomManager sharedManager] zoomScale];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)startSelectionLineWithPoint:(CGPoint)point {
    [self moveCenterX:point.x Y:point.y];
    [self.selectionLine moveToPoint:point];
    [self setNeedsDisplay];
}

- (void)updateSelectionLineWithPoint:(CGPoint)point {
    // update line
    [self.selectionLine addLineToPoint:point];
    [self updateFrameWithPoint:point];
    // redraw
    [self setNeedsDisplay];
}

- (void)updateFrameWithPoint:(CGPoint)point {
    if ([self superview]) {
        // update constraints
//        self.leftConstraint.constant = self.selectionLine.bounds.origin.x - self.selectionLine.lineWidth / 2;
//        self.topConstraint.constant = self.selectionLine.bounds.origin.y - self.selectionLine.lineWidth / 2;
//        self.widthConstraint.constant = self.selectionLine.bounds.size.width + self.selectionLineWidth;
//        self.heightConstraint.constant = self.selectionLine.bounds.size.height + self.selectionLineWidth;
        CGFloat xmin = self.leftConstraint.constant;
        CGFloat ymin = self.topConstraint.constant;
        CGFloat xmax = xmin + self.widthConstraint.constant;
        CGFloat ymax = ymin + self.heightConstraint.constant;
        if (point.x - self.selectionLineWidth / 2 < xmin) {
            self.widthConstraint.constant += xmin - point.x + self.selectionLine.lineWidth;
            self.leftConstraint.constant = point.x - self.selectionLineWidth / 2;
        } else if (point.x + self.selectionLineWidth / 2 > xmax) {
            self.widthConstraint.constant += point.x - xmax + self.selectionLine.lineWidth;
        }
        if (point.y - self.selectionLineWidth / 2 < ymin) {
            self.heightConstraint.constant += ymin - point.y + self.selectionLine.lineWidth;
            self.topConstraint.constant = point.y - self.selectionLineWidth / 2;
        } else if (point.y + self.selectionLineWidth / 2 > ymax) {
            self.heightConstraint.constant += point.y - ymax + self.selectionLine.lineWidth;
        }
    } else {
        // update frame
        CGFloat xmin = self.frame.origin.x;
        CGFloat ymin = self.frame.origin.y;
        CGFloat xmax = self.frame.origin.x + self.frame.size.width;
        CGFloat ymax = self.frame.origin.y + self.frame.size.height;
        CGRect frame = self.frame;
        //        CGFloat zoomScale = [[ZoomManager sharedManager] zoomScale];
        if (point.x - self.selectionLineWidth / 2 < xmin) {
            frame.size.width += xmin - point.x + self.selectionLine.lineWidth;
            frame.origin.x = point.x - self.selectionLineWidth / 2;
        } else if (point.x + self.selectionLineWidth / 2 > xmax) {
            frame.size.width += point.x - xmax + self.selectionLine.lineWidth;
        }
        if (point.y - self.selectionLineWidth / 2 < ymin) {
            frame.size.height += ymin - point.y + self.selectionLine.lineWidth;
            frame.origin.y = point.y - self.selectionLineWidth / 2;
        } else if (point.y + self.selectionLineWidth / 2 > ymax) {
            frame.size.height += point.y - ymax + self.selectionLine.lineWidth;
        }
        self.frame = frame;
    }
}

//- (void)endSelectionLine {
//    // remove selection line
//    self.selectionLine = nil;
//    // update frame
//    self.frame = CGRectMake(0, 0, 0, 0);
//    [self setNeedsDisplay];
//}


- (void)drawRect:(CGRect)rect {
    // draw line
    if (self.selectionLine) {
        self.selectionLine.lineWidth = self.selectionLineWidth / [[ZoomManager sharedManager] zoomScale];
        [self.selectionLineColor setStroke];
        [self.selectionLine stroke];
    }
}

@end
