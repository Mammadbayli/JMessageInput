//
//  ViewController.m
//  JMessageInput_Example_Objc
//
//  Created by Javad on 25.04.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+JMessageInputDelegate.h"
@import JMessageInput;

@interface ViewController ()
@property (nonatomic) JMessageInput *input;
@end

@implementation ViewController

- (JMessageInput *)input {
    if (!_input) {
        _input = [[JMessageInput alloc] init];
        [_input setDelegate:self];
    }
    
    return _input;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self view] addSubview:[self input]];
    [[self input] setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UILayoutGuide *safeAreaLayoutGuide = [[self view] safeAreaLayoutGuide];
    
    [NSLayoutConstraint activateConstraints:@[
        [[[self input] bottomAnchor] constraintEqualToAnchor:[safeAreaLayoutGuide bottomAnchor]],
        [[[self input] leadingAnchor] constraintEqualToAnchor:[safeAreaLayoutGuide leadingAnchor]],
        [[[self input] trailingAnchor] constraintEqualToAnchor:[safeAreaLayoutGuide trailingAnchor]]
    ]];

}


@end
