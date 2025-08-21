export THEOS=/home/codespace/theos
ARCHS = arm64

DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Alert

$(TWEAK_NAME)_FRAMEWORKS = UIKit CoreGraphics QuartzCore
$(TWEAK_NAME)_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

# Các file cần compile
$(TWEAK_NAME)_FILES = \
    Alert.mm \
    Vendor/FLAnimatedImage/FLAnimatedImage.m \
    Vendor/FLAnimatedImage/FLAnimatedImageView.m \
    FPS/FPSDisplay.m

# Đường dẫn header nếu cần (nếu header không cùng thư mục)
$(TWEAK_NAME)_CFLAGS += -IVendor/FLAnimatedImage -IFPS

include $(THEOS_MAKE_PATH)/tweak.mk
