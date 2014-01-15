//
//  SliderView.m
//  PaintCodeTutorial
//
//  Created by Oliver Foggin on 15/01/2014.
//  Copyright (c) 2014 Oliver Foggin. All rights reserved.
//

#import "SliderView.h"

@implementation SliderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _minimumValue = 0.0;
        _maximumValue = 1.0;
        _value = 0.5;

        _thumbColor = [UIColor colorWithRed: 0.833 green: 0.833 blue: 0.833 alpha: 1];
        _maximumTrackColor = [UIColor colorWithRed: 0.833 green: 0.833 blue: 0.833 alpha: 1];
        _minimumTrackColor = [UIColor colorWithRed: 1 green: 0 blue: 0 alpha: 1];

        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (void)setMaximumValue:(CGFloat)maximumValue
{
    _maximumValue = maximumValue;

    [self setNeedsDisplay];
}

- (void)setMinimumValue:(CGFloat)minimumValue
{
    _minimumValue = minimumValue;

    [self setNeedsDisplay];
}

- (void)setValue:(CGFloat)value
{
    _value = MIN(self.maximumValue, MAX(self.minimumValue, value));

    [self setNeedsDisplay];
}

- (CGFloat)percentageValue
{
    if (self.maximumValue == self.minimumValue) {
        return 0.5;
    }

    return (self.value - self.minimumValue) / (self.maximumValue - self.minimumValue);
}

- (CGFloat)valueFromPercentage:(CGFloat)percentage
{
    return percentage * (self.maximumValue - self.minimumValue) + self.minimumValue;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];

    return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];

    CGPoint lastPoint = [touch locationInView:self];

    [self moveThumbToPoint:lastPoint];

    [self sendActionsForControlEvents:UIControlEventValueChanged];

    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)moveThumbToPoint:(CGPoint)point
{
    CGFloat percentage = (point.x - 10) / (CGRectGetWidth(self.bounds) - 20);

    self.value = [self valueFromPercentage:percentage];

    [self setNeedsDisplay];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, 20);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();

//// Color Declarations
    UIColor* thumbColor = self.thumbColor;
    UIColor* minimumTrackColor = self.minimumTrackColor;
    UIColor* maximumTrackColor = self.maximumTrackColor;

//// Shadow Declarations
    UIColor* shadow = [UIColor darkGrayColor];
    CGSize shadowOffset = CGSizeMake(0.1, -0.1);
    CGFloat shadowBlurRadius = 3;

//// Frames
    CGRect sliderFrame = rect;

//// Subframes
    CGRect track = CGRectMake(CGRectGetMinX(sliderFrame), CGRectGetMinY(sliderFrame) + floor((CGRectGetHeight(sliderFrame) - 4) * 0.50000 + 0.5), CGRectGetWidth(sliderFrame), 4);
    CGRect trackFrame = CGRectMake(CGRectGetMinX(track) + floor(CGRectGetWidth(track) * 0.00000 + 0.5), CGRectGetMinY(track) + CGRectGetHeight(track) - 4, floor(CGRectGetWidth(track) * 1.00000 + 0.5) - floor(CGRectGetWidth(track) * 0.00000 + 0.5), 4);

    CGFloat percentage = [self percentageValue];

//// Abstracted Attributes
    CGRect thumbRect = CGRectMake(CGRectGetMinX(sliderFrame) + floor((CGRectGetWidth(sliderFrame) - 20) * percentage), CGRectGetMinY(sliderFrame) + floor((CGRectGetHeight(sliderFrame) - 20) * 0.50000 + 0.5), 20, 20);
    CGRect minimumTrackRect = CGRectMake(CGRectGetMinX(trackFrame), CGRectGetMinY(trackFrame), floor((CGRectGetWidth(trackFrame)) * percentage), 4);
    CGRect maximumTrackRect = CGRectMake(CGRectGetMinX(trackFrame) + floor((CGRectGetWidth(trackFrame)) * percentage), CGRectGetMinY(trackFrame), CGRectGetWidth(trackFrame) - floor((CGRectGetWidth(trackFrame)) * percentage), 4);

//// Track
    {
        //// Minimum Track Drawing
        UIBezierPath* minimumTrackPath = [UIBezierPath bezierPathWithRoundedRect: minimumTrackRect byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: CGSizeMake(2, 2)];
        [minimumTrackPath closePath];
        [minimumTrackColor setFill];
        [minimumTrackPath fill];


        //// Maximum Track Drawing
        UIBezierPath* maximumTrackPath = [UIBezierPath bezierPathWithRoundedRect: maximumTrackRect byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii: CGSizeMake(2, 2)];
        [maximumTrackPath closePath];
        [maximumTrackColor setFill];
        [maximumTrackPath fill];
    }


//// Thumb Drawing
    UIBezierPath* thumbPath = [UIBezierPath bezierPathWithOvalInRect: thumbRect];
    [thumbColor setFill];
    [thumbPath fill];

////// Thumb Inner Shadow
    CGRect thumbBorderRect = CGRectInset([thumbPath bounds], -shadowBlurRadius, -shadowBlurRadius);
    thumbBorderRect = CGRectOffset(thumbBorderRect, -shadowOffset.width, -shadowOffset.height);
    thumbBorderRect = CGRectInset(CGRectUnion(thumbBorderRect, [thumbPath bounds]), -1, -1);

    UIBezierPath* thumbNegativePath = [UIBezierPath bezierPathWithRect: thumbBorderRect];
    [thumbNegativePath appendPath: thumbPath];
    thumbNegativePath.usesEvenOddFillRule = YES;

    CGContextSaveGState(context);
    {
        CGFloat xOffset = shadowOffset.width + round(thumbBorderRect.size.width);
        CGFloat yOffset = shadowOffset.height;
        CGContextSetShadowWithColor(context,
                CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                shadowBlurRadius,
                shadow.CGColor);

        [thumbPath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(thumbBorderRect.size.width), 0);
        [thumbNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [thumbNegativePath fill];
    }
    CGContextRestoreGState(context);

}

@end
