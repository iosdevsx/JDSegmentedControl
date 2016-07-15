//
//  ViewController.m
//  CustomSegment
//
//  Created by Юрий Логинов on 14.07.16.
//  Copyright © 2016 Юрий Логинов. All rights reserved.
//

#import "ViewController.h"
#import "JDCustomSegment.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet JDCustomSegment *segmentControl;
@property (weak, nonatomic) IBOutlet UILabel *segmentLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.segmentControl.items = @[@"one", @"two", @"three"];
    [self.segmentControl addTarget:self action:@selector(actionSegmentValueChanged) forControlEvents:UIControlEventValueChanged];
    [self printLabel];
    [self.view addSubview:self.segmentControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)actionSegmentValueChanged {
    [self printLabel];
}

- (void)printLabel {
    self.segmentLabel.text = [NSString stringWithFormat:@"Selected Index: %ld", self.segmentControl.selectedIndex];
}

@end
