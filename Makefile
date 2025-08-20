export THEOS=/home/codespace/theos
ARCHS = arm64

DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Alert

$(TWEAK_NAME)_FRAMEWORKS = UIKit
$(TWEAK_NAME)_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

# Bao gồm thư viện FLAnimatedImage vào quá trình biên dịch
$(TWEAK_NAME)_FILES = \
    Alert.mm \
    Vendor/FLAnimatedImage/FLAnimatedImage.m \
    Vendor/FLAnimatedImage/FLAnimatedImageView.m

include $(THEOS_MAKE_PATH)/tweak.mk

# Sau khi cài tweak, tự động copy file GIF vào thiết bị
after-install::
	install.exec "cp $(THEOS_PROJECT_DIR)/Resources/yen.gif /Library/Application\\ Support/AlertNotifier/"
