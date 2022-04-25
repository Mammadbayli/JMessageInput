//
//  ViewController.m
//  JMessageInput_Example_Objc
//
//  Created by Javad on 25.04.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

#import "ViewController.h"
@import JMessageInput;

@interface ViewController ()
@property (nonatomic) JMessageInput *input;
@end

@implementation ViewController

- (JMessageInput *)input {
    if (!_input) {
        _input = [[JMessageInput alloc] init];
    }
    
    return _input;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] addSubview:[self input]];
    // Do any additional setup after loading the view.
}


@end
