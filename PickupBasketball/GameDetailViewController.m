//
//  GameDetailViewController.m
//  PickupBasketball
//
//  Created by Wei Deng on 12/2/13.
//  Copyright (c) 2013 Wei Deng. All rights reserved.
//

#import "GameDetailViewController.h"

@interface GameDetailViewController ()

@end

@implementation GameDetailViewController
@synthesize timeLabel;
@synthesize time;
@synthesize locationLabel;
@synthesize numPlayersLabel;
@synthesize gameId;
@synthesize location;
@synthesize numPlayers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	// Do any additional setup after loading the view.
    //Show the game time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *timeForLabel = [dateFormatter stringFromDate:time];
    timeLabel.text = timeForLabel;
    
    //Show game location
    locationLabel.text = location;
    
    //Show number of players
    NSString *temp = [NSString stringWithFormat:@"%d", numPlayers];
    numPlayersLabel.text = temp;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)joinGame {
    NSLog(@"Button pressed");
}

@end
