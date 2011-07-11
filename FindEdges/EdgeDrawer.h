//
//  EdgeDrawer.h
//  FindEdges
//
//  Created by Alex Nichol on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EdgeFinder.h"


@interface EdgeDrawer : UIView {
    UIImage * image;
}

- (void)setImage:(UIImage *)image;

@end
