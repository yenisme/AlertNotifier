#import <UIKit/UIKit.h>
#import "FPSDisplay.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface FPSDisplay ()
@property (strong, nonatomic) UILabel *displayLabel;
@property (strong, nonatomic) CADisplayLink *link;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSTimeInterval lastTime;
@end

@implementation FPSDisplay

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self shareFPSDisplay];
    });
}

+ (instancetype)shareFPSDisplay {
    static FPSDisplay *shareDisplay;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDisplay = [[FPSDisplay alloc] init];
    });
    return shareDisplay;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDisplayLabel];
    }
    return self;
}

- (void)initDisplayLabel {

    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;

    // Cách bottom ~40px để tránh Home Indicator
    CGRect frame = CGRectMake((screenW - (screenW/2 + 10)) / 2.0,
                              screenH - 40.0,
                              screenW/2 + 10,
                              20);

    self.displayLabel = [[UILabel alloc] initWithFrame:frame];
    self.displayLabel.textAlignment = NSTextAlignmentCenter;
    self.displayLabel.userInteractionEnabled = NO;
    self.displayLabel.text = @"Created by Khổng Mạnh Yên";
    self.displayLabel.font = [UIFont boldSystemFontOfSize:12.0];

    // ---- Glow / Shadow effect ----
    self.displayLabel.layer.shadowRadius  = 6;
    self.displayLabel.layer.shadowOpacity = 0.9;
    self.displayLabel.layer.shadowColor   = [UIColor whiteColor].CGColor;
    self.displayLabel.layer.shadowOffset  = CGSizeZero;

    // ----- Gradient Layer -----
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.displayLabel.bounds;
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint   = CGPointMake(1, 0.5);

    // mask gradient = text
    self.gradientLayer.mask = self.displayLabel.layer;
    [self.displayLabel.layer addSublayer:self.gradientLayer];

    [[UIApplication sharedApplication].keyWindow addSubview:self.displayLabel];
    [self initCADisplayLink];
}

- (void)initCADisplayLink {
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)tick:(CADisplayLink *)link
{
    if (self.lastTime == 0) {
        self.lastTime = link.timestamp;
        return;
    }
    self.count += 1;
    NSTimeInterval delta = link.timestamp - _lastTime;
    float fps = 0;
    if (delta >= 1.f) {
        self.lastTime = link.timestamp;
        fps = self.count / delta;
        self.count = 0;
    }
    [self updateDisplayLabelText:fps];
}

- (void)updateDisplayLabelText:(float)fps
{
    // ---- Rainbow gradient update ----
    static CGFloat hue = 0.0f;
    hue += 0.005;
    if (hue > 1.0) hue = 0.0;

    UIColor *c1 = [UIColor colorWithHue:hue saturation:0.8 brightness:1 alpha:0.9];
    UIColor *c2 = [UIColor colorWithHue:fmod(hue + 0.33, 1.0) saturation:0.8 brightness:1 alpha:0.9];
    UIColor *c3 = [UIColor colorWithHue:fmod(hue + 0.66, 1.0) saturation:0.8 brightness:1 alpha:0.9];

    self.gradientLayer.colors = @[(id)c1.CGColor, (id)c2.CGColor, (id)c3.CGColor];

    // move gradient
    CGFloat offset = fmod(hue * 1.8, 1.0);
    self.gradientLayer.startPoint = CGPointMake(offset, 0.5);
    self.gradientLayer.endPoint   = CGPointMake(offset + 1.0, 0.5);
}
// ----- Scale Animation (pulse effect) -----
    static BOOL growing = YES;
    CGFloat scale = (growing ? 1.0f + 0.005f : 1.0f - 0.005f);

    self.displayLabel.transform = CGAffineTransformScale(self.displayLabel.transform, scale, scale);

    if (scale > 1.08f) growing = NO;
    if (scale < 1.0f)  growing = YES;

@end
