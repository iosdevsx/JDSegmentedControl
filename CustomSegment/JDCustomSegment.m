//
//  JDCustomSegment.m
//  CustomSegment
//
//  Created by Юрий Логинов on 14.07.16.
//  Copyright © 2016 Юрий Логинов. All rights reserved.
//

#import "JDCustomSegment.h"

//SegmentControl

@interface JDCustomSegment()

@property (strong, nonatomic) NSMutableArray <UILabel *> *labels;

@property (strong, nonatomic) UIView *thumbView;

@end

IB_DESIGNABLE

@implementation JDCustomSegment
@synthesize items = _items;


#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray <NSString *> *)items
{
    self = [super init];
    if (self) {
        self.items = items;
        [self setupView];
    }
    return self;
}

#pragma mark - Control setup & Autolayout

- (void)setupView {
    self.layer.cornerRadius = 5.f;
    
    [self setupLabels];
    [self setupConstraintsForItems:self.labels mainView:self withPadding:0];
    [self insertSubview:self.thumbView atIndex:0];
}

- (void)setupLabels {
    
    for (UILabel *label in self.labels) {
        [label removeFromSuperview];
    }
    
    self.labels = [NSMutableArray array];
    
    for (NSInteger i = 1; i <= self.items.count; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        label.text = self.items[i - 1];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = i == 1 ? self.selectedLabelColor : self.unselectedLabelColor;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:label];
        [self.labels addObject:label];
    }
    
    [self setupConstraintsForItems:self.labels mainView:self withPadding:0];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect selectedFrame = self.bounds;
    NSInteger width = CGRectGetWidth(selectedFrame) / self.items.count;
    selectedFrame.size.width = width;
    self.thumbView.frame = selectedFrame;
    self.thumbView.backgroundColor = self.thumbColor;
    self.thumbView.layer.cornerRadius = self.viewRadius;
    
    [self displaySelectedIndex];
}

- (void)setupConstraintsForItems:(NSArray <UIView *> *)items mainView:(UIView *)view withPadding:(CGFloat )padding {
    [items enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        
        NSLayoutConstraint *rightConstraint;
        NSLayoutConstraint *leftConstraint;
        
        if (idx == items.count - 1) {
            rightConstraint = [NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant: -padding];
        } else {
            UIView *nextLabel = items[idx + 1];
            rightConstraint = [NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:nextLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant: -padding];
        }
        
        if (idx == 0) {
            leftConstraint = [NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:padding];
        } else {
            UIView *previousLabel = items[idx - 1];
            leftConstraint = [NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:padding];
            
            UIView *firstLabel = items[0];
            
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:firstLabel attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
            
            [view addConstraint:width];
        }
        
        [view addConstraints:@[topConstraint, bottomConstraint, rightConstraint, leftConstraint]];
    }];
}

#pragma mark - Touches & Actions

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint point = [touch locationInView:self];
    
    __block NSUInteger index = NSNotFound;
    
    [self.labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint locationInView = [obj convertPoint:point fromView:self];
        if ([obj pointInside:locationInView withEvent:event]) {
            index = idx;
        }
    }];
    
    if (index != NSNotFound) {
        self.selectedIndex = index;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    return NO;
}

- (void)displaySelectedIndex {
    for (UILabel *label in self.labels) {
        label.textColor = self.unselectedLabelColor;
    }
    
    UILabel *label = [self.labels objectAtIndex:self.selectedIndex];
    label.textColor = self.selectedLabelColor;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.thumbView.frame = label.frame;
    }];
}

#pragma mark - Setters & Getters

-(void)setItems:(NSArray<NSString *> *)items {
    _items = items;
    [self setupLabels];
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self displaySelectedIndex];
}


-(UIView *)thumbView {
    if (!_thumbView) {
        _thumbView = [UIView new];
    }
    return _thumbView;
}

-(void)setSelectedLabelColor:(UIColor *)selectedLabelColor {
    _selectedLabelColor = selectedLabelColor;
    [self setColors];
}

-(void)setUnselectedLabelColor:(UIColor *)unselectedLabelColor {
    _unselectedLabelColor = unselectedLabelColor;
    [self setColors];
}

-(UIColor *)thumbColor {
    if (!_thumbColor) {
        _thumbColor = [UIColor whiteColor];
    }
    return  _thumbColor;
}

-(NSArray<NSString *> *)items {
    if (!_items) {
        _items = @[@"First", @"Second", @"Third"];
    }
    return _items;
}

- (void)setColors {
    for (UILabel *label in self.labels) {
        label.textColor = self.unselectedLabelColor;
    }
    
    if (self.labels.count > 0) {
        self.labels[0].textColor = self.selectedLabelColor;
    }
    
    self.thumbView.backgroundColor = self.thumbColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    for (UILabel *label in self.labels) {
        label.font = font;
    }
}

@end
