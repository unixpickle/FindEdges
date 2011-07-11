//
//  FindEdgesViewController.m
//  FindEdges
//
//  Created by Alex Nichol on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FindEdgesViewController.h"

@implementation FindEdgesViewController

- (void)dealloc
{
	[recycling release];
	[trash release];
	[pickle release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	drawer = [[EdgeDrawer alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
	[[self view] addSubview:drawer];
	[drawer setImage:[UIImage imageNamed:@"monkeys.png"]];
	[drawer release];
	pickle = [[UIButton alloc] initWithFrame:CGRectMake(0, 320, [[self view] frame].size.width / 3, [[self view] frame].size.height - 320)];
	trash = [[UIButton alloc] initWithFrame:CGRectMake([[self view] frame].size.width / 3, 320, [[self view] frame].size.width / 3, [[self view] frame].size.height - 320)];
	recycling = [[UIButton alloc] initWithFrame:CGRectMake([[self view] frame].size.width / 3 * 2, 320, [[self view] frame].size.width / 3, [[self view] frame].size.height - 320)];
	[pickle setImage:[UIImage imageNamed:@"pickle.png"] forState:UIControlStateNormal];
	[trash setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
	[recycling setImage:[UIImage imageNamed:@"monkeys.png"] forState:UIControlStateNormal];	
	[pickle addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
	[trash addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
	[recycling addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:recycling];
	[[self view] addSubview:trash];
	[[self view] addSubview:pickle];
}

- (void)changeImage:(UIButton *)sendrar {
	[drawer setImage:[sendrar imageForState:UIControlStateNormal]];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
