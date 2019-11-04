//
//  CustomTextView.m
//  Quran
//
//  Created by Mostafa Saleh on 11/4/19.
//

#import "CustomTextView.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation CustomTextView

- (void)_hookGestures {
    /*
     * as this can get called multiple times, we use a simple flag to keep it in check.
     */
    if (_hasHookedGesturesForiOS13LinkTapBug) {
        return;
    }

    _hasHookedGesturesForiOS13LinkTapBug = YES;

    Class longPress = UILongPressGestureRecognizer.class;
    Class linkTap = UITapGestureRecognizer.class;

    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if ([gesture isKindOfClass:longPress] || [gesture isKindOfClass:linkTap]) {
            gesture.delegate = self;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    Class longPress = UILongPressGestureRecognizer.class;
    Class linkTap = UITapGestureRecognizer.class;
    Class scrollViewPan = NSClassFromString(@"UIScrollViewPanGestureRecognizer");

    if ([gestureRecognizer isKindOfClass:longPress] || [gestureRecognizer isKindOfClass:linkTap]) {
#ifdef DEBUG
        NSLog(@"Other gesture: %@", otherGestureRecognizer);
#endif
        if ([otherGestureRecognizer isKindOfClass:scrollViewPan]) {
            return NO;
        }

        return YES;
    }

    return YES;
}

//- (NSRange) selectedRange {
//    return Nil;
//}

- (NSRange)selectedRange{
    return NSMakeRange(0, 0);
}

#pragma mark - Usage

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    // we only need to call this on iOS 13.
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")) {
        [self _hookGestures];
    }
}

@end
