//
//  FindEdgesAppDelegate.h
//  FindEdges
//
//  Created by Alex Nichol on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindEdgesViewController;

@interface FindEdgesAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet FindEdgesViewController *viewController;

@end
