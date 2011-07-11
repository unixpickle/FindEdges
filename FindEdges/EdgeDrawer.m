//
//  EdgeDrawer.m
//  FindEdges
//
//  Created by Alex Nichol on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EdgeDrawer.h"


@implementation EdgeDrawer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImage:(UIImage *)anImage {
	[image autorelease];
	image = [anImage retain];
	[self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
	[image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
	
	CGContextSetRGBStrokeColor(context, 0.2, 0.2, 1, 1);
	CGContextSetLineWidth(context, 2);
	
	EdgeFinder * finder = [[EdgeFinder alloc] initWithImage:image];
	imageCoordinateList coords;
	int num = 0;
	while ([finder nextObject:&coords]) {
		if (coords.numberOfCoords > 1) {
			num++;
			CGContextSaveGState(context);
			CGContextBeginPath(context);
			for (int i = 0; i < coords.numberOfCoords; i++) {
				if (i == 0) {
					CGContextMoveToPoint(context, coords.coords[i].x, coords.coords[i].y);
				} else {
					CGContextAddLineToPoint(context, coords.coords[i].x, coords.coords[i].y);
				}
			}
			CGContextStrokePath(context);
			CGContextRestoreGState(context);
			image_coordinate_list_free(coords);
		}
	}
	const char * text = [[NSString stringWithFormat:@"%d objects", num] UTF8String];
    CGContextSelectFont(context, "Helvetica", 14.0, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGAffineTransform xform = CGAffineTransformMake(1.0,  0.0,
													0.0, -1.0,
													0.0,  0.0);
    CGContextSetTextMatrix(context, xform);
    CGContextShowTextAtPoint(context, 10, [self frame].size.height - 18, text, strlen(text));
	
	NSLog(@"Found %d objects", num);
	[finder release];
}


- (void)dealloc {
    [super dealloc];
}

@end
