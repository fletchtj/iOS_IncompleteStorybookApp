//
//  recordViewController.h
//  IncompleteStorybookApp
//
//  Created by TJ Fletcher on 12/3/12.
//  Copyright (c) 2012 TJ Fletcher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ModalViewControllerDelegate <NSObject>
- (void)didDismissModalView;
@end

@interface recordViewController : UIViewController {
    id<ModalViewControllerDelegate> delegate;
}
@property (nonatomic, strong) id<ModalViewControllerDelegate>delegate;

@end
