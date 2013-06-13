//
//  com_glazumAppDelegate.h
//  glazum-ios-example
//
//  Created by Mikhail Shkutkov on 6/13/13.
//  Copyright (c) 2013 Mikhail Shkutkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class com_glazumViewController;

@interface com_glazumAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) com_glazumViewController *viewController;

@end
