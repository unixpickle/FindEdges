//
//  EdgeFinder.m
//  FindEdges
//
//  Created by Alex Nichol on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EdgeFinder.h"

#define kAlphaMin 50

imageCoordinate * image_coordinate_list_get (imageCoordinateList list, int index) {
	return &(list.coords[index]);
}
imageCoordinate * image_coordinate_list_get_second_back (imageCoordinateList list) {
	if (list.numberOfCoords >= 2) {
		return image_coordinate_list_get(list, list.numberOfCoords - 2);
	}
	return NULL;
}
BOOL image_coordinate_list_contains (imageCoordinateList list, imageCoordinate coordinate) {
	int i;
	for (i = 0; i < list.numberOfCoords; i++) {
		imageCoordinate coord = list.coords[i];
		if (coord.x == coordinate.x && coord.y == coordinate.y) {
			return YES;
		}
	}
	//printf("Doesn't contain: %d %d\n", coordinate.x, coordinate.y);
	return NO;
}
void image_coordinate_list_put (imageCoordinateList * list, imageCoordinate coordinate) {
	list->coords = realloc(list->coords, sizeof(imageCoordinate) * (list->numberOfCoords + 1));
	assert(list->coords != NULL);
	NSCAssert(list->coords != NULL, @"Failed to reallocate coordinate list!");
	list->coords[list->numberOfCoords].x = coordinate.x;
	list->coords[list->numberOfCoords].y = coordinate.y;
	list->numberOfCoords += 1;
}
void image_coordinate_list_free (imageCoordinateList list) {
	free(list.coords);
}
BOOL image_coordinate_is_touching (imageCoordinate coord, imageCoordinate anotherCoord) {
	if (anotherCoord.x == coord.x || anotherCoord.x - 1 == coord.x || anotherCoord.x + 1 == coord.x)
		if (anotherCoord.y == coord.y || anotherCoord.y - 1 == coord.y || anotherCoord.y + 1 == coord.y) return YES;
	return NO;
}

@interface EdgeFinder (Private)

- (void)getPixel:(unsigned char *)pixel atCoord:(imageCoordinate)point;
- (BOOL)isPixelEdge:(imageCoordinate)coord;
- (BOOL)findNextEdge:(imageCoordinate *)nextEdge forEdgePoint:(imageCoordinate)existingEdge;

/**
 * @param coord1 The new pixel.
 * @param coord2 The old pixel.
 */
- (int)numberOfBlanksTouchingSameEdge:(imageCoordinate)coord1 asPixel:(imageCoordinate)coord2;

@end

@implementation EdgeFinder

/**
 * Creates a new edge finder with an image.
 */
- (id)initWithImage:(UIImage *)theImage {
	if ((self = [super init])) {
		coordList.coords = (imageCoordinate *)malloc(sizeof(imageCoordinate));
		coordList.numberOfCoords = 0;
		image = [[ANImageBitmapRep alloc] initWithImage:theImage];
		imgSize.x = round([image size].width);
		imgSize.y = round([image size].height);
	}
	return self;
}

/**
 * Finds the next "object" in the image if available.
 * @param theObject A pass by reference object that will be set to contain
 * the coordinates of the edges of the object if one is found.
 * @return If another object is found, YES will be returned.
 */
- (BOOL)nextObject:(imageCoordinateList *)theObject {
	imageCoordinateList list;
	list.numberOfCoords = 0;
	list.coords = malloc(sizeof(imageCoordinate));	
	for (int y = 0; y < imgSize.y; y++) {
		for (int x = 0; x < imgSize.x; x++) {
			// find me an edge.
			imageCoordinate coord;
			coord.x = x;
			coord.y = y;
			if ([self isPixelEdge:coord]) {
				if (!image_coordinate_list_contains(coordList, coord)) {
					image_coordinate_list_put(&coordList, coord);
					imageCoordinate nextLine = coord;
					image_coordinate_list_put(&list, nextLine);
					// printf("%d,%d\n", nextLine.x, nextLine.y);
					while ([self findNextEdge:&nextLine forEdgePoint:nextLine]) {
						image_coordinate_list_put(&list, nextLine);
						image_coordinate_list_put(&coordList, nextLine);
						// printf("%d,%d\n", nextLine.x, nextLine.y);
					}
					if (theObject) *theObject = list;
					return YES;
				}
			}
		}
	}
	image_coordinate_list_free(list);
	return NO;
}

- (void)getPixel:(unsigned char *)pixel atCoord:(imageCoordinate)point {
	if (point.x < 0 || point.y < 0 || point.x >= imgSize.x || point.y >= imgSize.y) {
		bzero(pixel, 4);
		return;
	}
	[image get255Pixel:pixel atX:point.x y:point.y];
}

- (BOOL)isPixelEdge:(imageCoordinate)coord {
	// go through all sides of the coordinate
	unsigned char coordPixel[4];
	[self getPixel:coordPixel atCoord:coord];
	if (coordPixel[3] >= kAlphaMin) return NO;
	for (int x = coord.x - 1; x <= coord.x + 1; x++) {
		for (int y = coord.y - 1; y <= coord.y + 1; y++) {
				unsigned char pixel[4];
				imageCoordinate coordinate;
				coordinate.x = x;
				coordinate.y = y;
				[self getPixel:pixel atCoord:coordinate];
				if (pixel[3] >= kAlphaMin) return YES;
		}
	}
	return NO;
}

- (BOOL)findNextEdge:(imageCoordinate *)nextEdge forEdgePoint:(imageCoordinate)existingEdge {
	// 55,4
	imageCoordinate foundPoint;
	BOOL pointFound = NO;
	int count = 0;
	for (int x = existingEdge.x - 1; x <= existingEdge.x + 1; x++) {
		for (int y = existingEdge.y - 1; y <= existingEdge.y + 1; y++) {
			imageCoordinate newCoord;
			newCoord.x = x;
			newCoord.y = y;
			if ([self isPixelEdge:newCoord] && !image_coordinate_list_contains(coordList, newCoord)) {
				// int ccount = 0;
				int ccount = [self numberOfBlanksTouchingSameEdge:newCoord asPixel:existingEdge];
				imageCoordinate * prevCoord = image_coordinate_list_get_second_back(coordList);
				if (prevCoord != NULL) {
					if (image_coordinate_is_touching(newCoord, *prevCoord)) {
						ccount++;
					}
					ccount += [self numberOfBlanksTouchingSameEdge:newCoord asPixel:*prevCoord];
				}
				if (ccount > count) {
					count = ccount;
					foundPoint = newCoord;
					pointFound = YES;
				}
			}
		}
	}
	if (pointFound && nextEdge) {
		*nextEdge = foundPoint;
	}
	return pointFound;
}

- (int)numberOfBlanksTouchingSameEdge:(imageCoordinate)coord1 asPixel:(imageCoordinate)coord2 {
	unsigned char coordPixel[4];
	[self getPixel:coordPixel atCoord:coord1];
	if (coordPixel[3] >= kAlphaMin) return 0;
	int count = 0;
	for (int x = coord1.x - 1; x <= coord1.x + 1; x++) {
		for (int y = coord1.y - 1; y <= coord1.y + 1; y++) {
			imageCoordinate theCoord;
			theCoord.x = x;
			theCoord.y = y;
			if (image_coordinate_is_touching(coord2, theCoord)) {
				if (x >= 0 && x < imgSize.x) {
					if (y >= 0 && y < imgSize.y) {
						imageCoordinate coordinate;
						coordinate.x = x;
						coordinate.y = y;
						unsigned char pixel[4];
						[self getPixel:pixel atCoord:coordinate];
						if (pixel[3] >= kAlphaMin) count ++;
					} else count ++;
				} else count ++;
			}
		}
	}
	return count;
}

- (void)dealloc {
	image_coordinate_list_free(coordList);
	[image release];
	[super dealloc];
}

@end
