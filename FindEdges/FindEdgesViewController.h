//
//  FindEdgesViewController.h
//  FindEdges
//
//  Created by Alex Nichol on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EdgeDrawer.h"

@interface FindEdgesViewController : UIViewController {
	EdgeDrawer * drawer;
	UIButton * pickle;
	UIButton * trash;
	UIButton * recycling;
}

- (void)changeImage:(UIButton *)sendrar;

@end
