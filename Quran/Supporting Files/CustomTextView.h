//
//  CustomTextView.h
//  Quran
//
//  Created by Mostafa Saleh on 11/4/19.
//

/*
 * The issue this whole time was the UITextView would not wait for the pan gesture of it's hosting UIScrollView to fail.
 * Once we find out the correct gestures to hook into, we can ensure they don't get recognized simultaneously.
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTextView : UITextView <UIGestureRecognizerDelegate>
{
    BOOL _hasHookedGesturesForiOS13LinkTapBug;
}

- (void)_hookGestures;

@end

NS_ASSUME_NONNULL_END
