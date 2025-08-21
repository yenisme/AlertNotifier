#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "FPSDisplay.h"

__attribute__((constructor))
static void showAlertAfterLaunch() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
        // Bật overlay FPS
        [[FPSDisplay sharedInstance] start];

        // ====== Tạo Alert ======
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Khổng Mạnh Yên"
                                            message:@"Inbox thì cứ thêm vài từ \"Mình sẽ trả phí\" là được 😆"
                                     preferredStyle:UIAlertControllerStyleAlert];

        // ====== Đổi màu tiêu đề ======
        NSMutableAttributedString *titleAttr =
        [[NSMutableAttributedString alloc] initWithString:@"Khổng Mạnh Yên"];
        [titleAttr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor systemGreenColor]
                          range:NSMakeRange(0, titleAttr.length)];
        [alert setValue:titleAttr forKey:@"attributedTitle"];

        // ====== Load GIF ======
        NSString *gifPath = @"/Library/Application Support/AlertNotifier/yen.gif";
        NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
        if (gifData) {
            FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
            FLAnimatedImageView *gifView = [[FLAnimatedImageView alloc] init];
            gifView.animatedImage = gifImage;
            gifView.frame = CGRectMake(20, 15, 40, 40); // 40x40
            gifView.contentMode = UIViewContentModeScaleAspectFit;

            [alert.view addSubview:gifView];
        }

        // ====== Nút Đóng ======
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Đóng"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [ok setValue:[UIColor redColor] forKey:@"titleTextColor"];
        [alert addAction:ok];

        // ====== Nút Website ======
        UIAlertAction *openLink = [UIAlertAction actionWithTitle:@"Website"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:@"https://manhyen.github.io/bio/"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url
                                                   options:@{}
                                         completionHandler:nil];
            }
        }];
        [openLink setValue:[UIColor systemPinkColor] forKey:@"titleTextColor"];
        [alert addAction:openLink];

        // ====== Hiển thị Alert ======
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIViewController *rootVC = keyWindow.rootViewController;
        [rootVC presentViewController:alert animated:YES completion:nil];
    });
}
