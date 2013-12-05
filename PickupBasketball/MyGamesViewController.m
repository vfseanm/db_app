//
//  MyGamesViewController.m
//  PickupBasketball
//
//  Created by Wei Deng on 12/3/13.
//  Copyright (c) 2013 Wei Deng. All rights reserved.
//

#import "MyGamesViewController.h"
#import "MyGameDetailViewController.h"
#import "Game.h"
#import "LoggedInUser.h"
#import "CJSONDeserializer.h"


@interface MyGamesViewController ()
{
    NSArray *locations;
    NSArray *games;
    NSArray *times;
    NSArray *Ids;
    NSArray *playerCounts;
    LoggedInUser *currentUser;
    NSString *userName;
}

@end

@implementation MyGamesViewController

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
    
    //get current user
    userName = [LoggedInUser getInstance].username;
    
    //Send request to get games
    
    NSString *queryString = [NSString stringWithFormat:@"http://dukedb-spm23.cloudapp.net/django/db-beers/see_my_games"];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:
                                                     queryString]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    [theRequest setHTTPMethod:@"POST"];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"Username", nil];
    
    NSError *error=nil;
    
    NSData* sendData = [NSJSONSerialization dataWithJSONObject:postDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    
    [theRequest setHTTPBody:sendData];
 
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&urlResponse error:&requestError];
    NSString *returnString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];

    if ([returnString isEqualToString:@"True"]) {
        NSLog(@"success!");
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
    
    }
    
    NSError *theError = nil;
    NSArray* jsonData = [[CJSONDeserializer deserializer] deserialize:response error:&theError];
    NSMutableArray *allGames = [NSMutableArray array];
    
    for (NSArray* object in jsonData) {
        Game *g1 = [[Game alloc] init];
        g1.id = 0;
        g1.numPlayers = 3;
        g1.location = [object objectAtIndex:1];
        NSString *str =[object objectAtIndex:2];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date = [formatter dateFromString:str];
        g1.time = date;
        [allGames addObject:g1];
    }
    games = [NSArray arrayWithArray:allGames];

    // Schedule the notifications
    
    for (Game *g in games) {
        NSDate *time = g.time;
        NSDate *pickerDate = [time dateByAddingTimeInterval:-300];
        
        //Just printing the time for debugging purposes.
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *fTime = [dateFormatter stringFromDate:pickerDate];
        NSLog(@"Alert will fire at:%@",fTime);
    
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];

        localNotification.fireDate = pickerDate;
        localNotification.alertBody = @"You have a game in hour";
        localNotification.alertAction = @"You have a game in hour";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication]applicationIconBadgeNumber] + 1;
    
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MyGameCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Game *g = [games objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *time = [dateFormatter stringFromDate:g.time];
    NSString *location = g.location;
    NSString *cellValue = [NSString stringWithFormat: @"%@ %@ %@", time, @" - ", location];
    cell.textLabel.text = cellValue;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMyGameDetail"]) {
        NSIndexPath *indexPath = [self.mainTableView indexPathForSelectedRow];
        MyGameDetailViewController *destViewController = segue.destinationViewController;
        Game *main = [games objectAtIndex:indexPath.row];
        destViewController.location = main.location;
        destViewController.time = main.time;
        destViewController.numPlayers = main.numPlayers;
    }
}


@end
