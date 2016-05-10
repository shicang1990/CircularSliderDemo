//
//  HXSectorSlider.m
//  CircularSliderDemo
//
//  Created by miaios on 16/4/29.
//  Copyright © 2016年 Mia Music. All rights reserved.
//

#import "HXSectorSlider.h"
#import "HXBezierCalculate.h"


static CGFloat ArcLineWidth = 4.0f;
static CGFloat SliderRadius = 15.0f;
static CGFloat OffsetY      = -20.0f;


@implementation HXSectorSlider {
    CAShapeLayer *_arcLayer;
    UIView       *_sliderView;
    
    CGPoint  _point1;
    CGPoint  _point2;
    CGPoint  _point3;
    CGPoint  _point4;
    CGPoint  _point5;
}

#pragma mark - Initialize Methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height + OffsetY;
    CGPoint startPoint = CGPointMake(0.0f, height);
    CGPoint endPoint = CGPointMake(width, height);
    CGPoint controlPoint = CGPointMake(width/2, height - width/5);
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    _arcLayer.path = path.CGPath;
    
    [HXBezierCalculate instanceWithStartPoint:startPoint endPoint:endPoint controlPoint:controlPoint];
    [self hanleSectionPoint];
}

#pragma mark - Configure Methods
- (void)setup {
    [self initConfigure];
    [self viewConfigure];
}

#pragma mark - Configure Methods
- (void)initConfigure {
    _arcLineWidth = ArcLineWidth;
    _sliderRadius = SliderRadius;
    
    _arcColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
    _sliderColor = [UIColor whiteColor];
}

- (void)viewConfigure {
    _arcLayer = [CAShapeLayer new];
    _arcLayer.lineWidth = _arcLineWidth;
    _arcLayer.fillColor = nil;
    _arcLayer.strokeColor = _arcColor.CGColor;
    [self.layer addSublayer:_arcLayer];
    
    _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _sliderRadius*2, _sliderRadius*2)];
    _sliderView.backgroundColor = _sliderColor;
    _sliderView.layer.cornerRadius = _sliderRadius;
    _sliderView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    _sliderView.layer.shadowColor = [UIColor grayColor].CGColor;
    _sliderView.layer.shadowOpacity = 0.5f;
    [self addSubview:_sliderView];
    
    [_sliderView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)]];
}

#pragma mark - Event Reponse
- (void)panGestureRecognizer:(UIPanGestureRecognizer* )panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateChanged: {
            [self moveHandleWithPoint:[panGesture locationInView:self]];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            [self moveEndWithPoint:[panGesture locationInView:self]];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Private Methods
- (void)hanleSectionPoint {
    HXBezierCalculate *calculate = [HXBezierCalculate instance];
    NSInteger sectionWidth = self.bounds.size.width / 6;
    _point1 = [calculate pointOnArcWithX:sectionWidth];
    _point2 = [calculate pointOnArcWithX:sectionWidth*2];
    _point3 = [calculate pointOnArcWithX:sectionWidth*3];
    _point4 = [calculate pointOnArcWithX:sectionWidth*4];
    _point5 = [calculate pointOnArcWithX:sectionWidth*5];
    
    _sliderView.center = _point1;
}

- (void)moveHandleWithPoint:(CGPoint)point {
    HXBezierCalculate *calculate = [HXBezierCalculate instance];
    _sliderView.center = [calculate pointOnArcWithX:point.x];
}

- (void)moveEndWithPoint:(CGPoint)point {
    CGFloat midpoint1_2 = (_point1.x + _point2.x) / 2;
    CGFloat midpoint2_3 = (_point2.x + _point3.x) / 2;
    CGFloat midpoint3_4 = (_point3.x + _point4.x) / 2;
    CGFloat midpoint4_5 = (_point4.x + _point5.x) / 2;
    
    CGPoint endPoint;
    if (point.x < midpoint1_2) {
        endPoint = _point1;
    } else if ((point.x >= midpoint1_2) && (point.x < midpoint2_3)) {
        endPoint = _point2;
    } else if ((point.x >= midpoint2_3) && (point.x < midpoint3_4)) {
        endPoint = _point3;
    } else if ((point.x >= midpoint3_4) && (point.x < midpoint4_5)) {
        endPoint = _point4;
    } else {
        endPoint = _point5;
    }
    [UIView animateWithDuration:0.3f animations:^{
        _sliderView.center = endPoint;
    }];
}

@end