//
//  UpdatesViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "UpdatesViewController.h"
#import "LoginViewController.h"


@interface UpdatesViewController ()

@end

@implementation UpdatesViewController

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
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self isFirstRun]){
        //check if first run, if so show login controller
        NSLog(@"isfirst run");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self presentViewController:loginVC animated:NO completion:nil];

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}

- (BOOL)isFirstRun
{
 //Check if it is the first run
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"isFirstRun"])
    {
        return NO;
    }
    
    [defaults setObject:@"ALREADY_FIRST_RUN" forKey:@"isFirstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Announcements";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"createdAt";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        
        
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //Get a reference to your string to base the cell size on.
//    NSString *cellText = [self.tableData objectAtIndex:indexPath.row];
//    //set the desired size of your textbox
//    CGSize constraint = CGSizeMake(widthOfMyTextBox, MAXFLOAT);
//    //set your text attribute dictionary
//    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
//    //get the size of the text box
//    CGRect textsize = [cellText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
//    //calculate your size
//    float textHeight = textsize.size.height +20;
//    //I have mine set for a minimum size
//    textHeight = (textHeight < 50.0) ? 50.0 : textHeight;
//    
//    return textHeight;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{

    static NSString *simpleTableIdentifier = @"UpdateCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    UILabel *titleLabel = (UILabel*) [cell viewWithTag:101];
    titleLabel.text = [object objectForKey:@"title"];
        NSLog(@"title: %@", [object objectForKey:@"title"]);
        
    
    UILabel *bodyText = (UILabel*) [cell viewWithTag:104];
    
    CGSize maximumLabelSize = CGSizeMake(298, FLT_MAX);
    NSString *bodyString =[object objectForKey:@"body"];
    CGSize expectedLabelSize = [bodyString sizeWithFont:bodyText.font constrainedToSize:maximumLabelSize lineBreakMode:bodyText.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = bodyText.frame;
    newFrame.size.height = expectedLabelSize.height;
    bodyText.frame = newFrame;
    bodyText.text = bodyString;
    
    UILabel *timeLabel = (UILabel*) [cell viewWithTag:103];
  //  NSDate *time = [NSDate date];
    NSDate *time = [object objectForKey:@"updatedAt"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd HH:mm a"];

    NSLog(@"date:  %@",time);
    timeLabel.text = [dateFormatter stringFromDate:time];
    
    
    return cell;
    }



@end
