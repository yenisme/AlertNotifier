#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

__attribute__((constructor))
static void showAlertAfterLaunch() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{

        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Khổng Mạnh Yên"
                                            message:@"Inbox thì cứ thêm vài từ \"Mình sẽ trả phí\" là được 😆"
                                     preferredStyle:UIAlertControllerStyleAlert];

        // ====== Load GIF ======
        NSString *gifPath = @"/Library/Application Support/AlertNotifier/yen.gif";
        NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
        if (gifData) {
            FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
            FLAnimatedImageView *gifView = [[FLAnimatedImageView alloc] init];
            gifView.animatedImage = gifImage;
            gifView.frame = CGRectMake(20, 15, 40, 40); // 40x40 ~ bằng tiêu đề
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
                [[UIApplication sharedApplication] openURL:url options:@{}
                                         completionHandler:nil];
            }
        }];
        [alert addAction:openLink];

        // Hiển thị Alert
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIViewController *rootVC = keyWindow.rootViewController;
        [rootVC presentViewController:alert animated:YES completion:nil];
    });
}