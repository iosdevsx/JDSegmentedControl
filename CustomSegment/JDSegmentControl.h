//
//  JDSegmentControl.h
//  CustomSegment
//
//  Created by Юрий Логинов on 14.07.16.
//  Copyright © 2016 Юрий Логинов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDSegmentControl : UIControl

@property (strong, nonatomic) NSArray <NSString *> *items;
@property (assign, nonatomic) NSUInteger selectedIndex;

//Customizable properties
@property (strong, nonatomic) IBInspectable UIColor *selectedLabelColor;
@property (strong, nonatomic) IBInspectable UIColor *unselectedLabelColor;
@property (strong, nonatomic) IBInspectable UIColor *thumbColor;
@property (strong, nonatomic) IBInspectable UIColor *borderColor;
@property (assign, nonatomic) IBInspectable CGFloat viewRadius;
@property (strong, nonatomic) IBInspectable UIFont *font;

- (instancetype)initWithItems:(NSArray <NSString *> *)items;

@end
