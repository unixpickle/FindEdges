//
//  EdgeFinder.h
//  FindEdges
//
//  Created by Alex Nichol on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANImageBitmapRep.h"

/* Structure defining a point in an image. */
typedef struct {
	short x;
	short y;
} imageCoordinate;

/* Structure defining a list of points in an image. */
typedef struct {
	imageCoordinate * coords;
	int numberOfCoords;
} imageCoordinateList;

imageCoordinate * image_coordinate_list_get (imageCoordinateList list, int index);
imageCoordinate * image_coordinate_list_get_second_back (imageCoordinateList list);
BOOL image_coordinate_list_contains (imageCoordinateList list, imageCoordinate coordinate);
void image_coordinate_list_put (imageCoordinateList * list, imageCoordinate coordinate);
void image_coordinate_list_free (imageCoordinateList list);

@interface EdgeFinder : NSObject {
    imageCoordinateList coordList;
	ANImageBitmapRep * image;
	imageCoordinate imgSize;
}

/**
 * Creates a new edge finder with an image.
 */
- (id)initWithImage:(UIImage *)theImage;

/**
 * Finds the next "object" in the image if available.
 * @param theObject A pass by reference object that will be set to contain
 * the coordinates of the edges of the object if one is found.
 * @return If another object is found, YES will be returned.
 */
- (BOOL)nextObject:(imageCoordinateList *)theObject;

@end
