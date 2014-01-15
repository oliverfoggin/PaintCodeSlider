//
//  SliderView.h
//  PaintCodeTutorial
//
//  Created by Oliver Foggin on 15/01/2014.
//  Copyright (c) 2014 Oliver Foggin. All rights reserved.
//

@interface SliderView : UIControl

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) CGFloat maximumValue;

@property (nonatomic, strong) UIColor *thumbColor;
@property (nonatomic, strong) UIColor *minimumTrackColor;
@property (nonatomic, strong) UIColor *maximumTrackColor;

@end
