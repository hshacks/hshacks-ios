//
//  AwardsViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "AwardsViewController.h"

@interface AwardsViewController ()

@end

@implementation AwardsViewController
@synthesize detailsArray;
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
    detailsArray = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Awards"];
    [query selectKeys:@[@"body"]];
    NSArray *objects = [query findObjects];
    for (int i = 0; i < objects.count;i++) {
        [detailsArray insertObject:[objects[i] objectForKey:@"details"] atIndex:0];
    }
    
    NSLog(@"details array from 1%@", detailsArray);

    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Awards";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"title";
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = NO;
        
        
        
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query orderByAscending:@"ID"];
    
    
    for (PFObject *object in self.objects) {
        
        NSString *details = [object objectForKey:@"details"];
        if(![detailsArray containsObject:details]){
            [detailsArray insertObject:details atIndex:0];
        }
    }
    
    NSLog(@"details array %@", detailsArray);
    
    
    return query;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get a reference to your string to base the cell size on.
    NSString *detailsString = [detailsArray objectAtIndex:indexPath.row];
    NSLog(@"detailsstring : %@", detailsString);
    //set the desired size of your textbox
    CGSize constraint = CGSizeMake(298, MAXFLOAT);
    //set your text attribute dictionary
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
    //get the size of the text box
    CGRect textsize = [detailsString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    //calculate your size
    float textHeight = textsize.size.height + 10;
    NSLog(@"%f", textHeight + 78);
    return textHeight + 78;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    static NSString *simpleTableIdentifier = @"AwardsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //Set title
    UILabel *titleLabel = (UILabel*) [cell viewWithTag:101];
    titleLabel.text = [object objectForKey:@"title"];
    
    //Set Prize label
    UILabel *prizeLabel = (UILabel*) [cell viewWithTag:102];
    prizeLabel.text = [object objectForKey:@"prize"];
    
    //Set detailstext, adjust size of label
    UILabel *detailsText = (UILabel*) [cell viewWithTag:104];
    
    NSString *detailsString =[object objectForKey:@"details"];
    
    CGSize constraint = CGSizeMake(298, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
    CGRect newFrame = [detailsString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    detailsText.frame = CGRectMake(10,79,newFrame.size.width, newFrame.size.height);
    detailsText.text = detailsString;
    [detailsText sizeToFit];
    
    //Set date label
    UILabel *companyLabel = (UILabel*) [cell viewWithTag:103];
    companyLabel.text = [object objectForKey:@"company"];
    
    
    return cell;
}



@end
