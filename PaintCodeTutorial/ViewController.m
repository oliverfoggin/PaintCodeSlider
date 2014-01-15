//
//  ViewController.m
//  PaintCodeTutorial
//
//  Created by Oliver Foggin on 15/01/2014.
//  Copyright (c) 2014 Oliver Foggin. All rights reserved.
//

#import "ViewController.h"
#import "SliderView.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    SliderView *slider = [[SliderView alloc] initWithFrame:CGRectZero];
    slider.minimumTrackColor = [UIColor greenColor];
    slider.maximumTrackColor = [UIColor lightGrayColor];
    slider.minimumValue = 13;
    slider.maximumValue = 10000;
    slider.value = 250;
    [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [slider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:slider];

    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"Hello World Above";
    [label1 sizeToFit];
    [label1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:label1];

    _valueLabel = [[UILabel alloc] init];
    _valueLabel.text = [NSString stringWithFormat:@"Value: %.2f", slider.value];
    [_valueLabel sizeToFit];
    [_valueLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_valueLabel];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[slider]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(slider)]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[label1]-[slider]-[_valueLabel]"
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(slider, label1, _valueLabel)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sliderChanged:(SliderView *)slider
{
    self.valueLabel.text = [NSString stringWithFormat:@"Value: %.2f", slider.value];
}

@end