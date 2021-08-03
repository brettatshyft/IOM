//
//  StaffTypeSelectionViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/26/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "StaffTypeSelectionViewController.h"
#import "Staff+Extension.h"
#import "IOMAnalyticsManager.h"

@interface StaffTypeSelectionViewController ()<IOMAnalyticsIdentifiable>

@end

@implementation StaffTypeSelectionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [[IOMAnalyticsManager shared] trackScreenView:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        //QHP Selected
        *_staffTypeID = [NSNumber numberWithInteger:StaffTypeQHP];
    }else{
        //Ancillary selected
        *_staffTypeID = [NSNumber numberWithInteger:StaffTypeAncillary];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString*)analyticsIdentifier
{
    return @"staff_type_selection";
}

@end
