//
//  DropdownController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/16/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "DropdownController.h"
#import "DropdownDataSource.h"

@interface DropdownController ()

@end

@implementation DropdownController

+ (UIPopoverController*)dropdownPopoverControllerForDropdownDataSource:(DropdownDataSource*)dataSource withDelegate:(id<DropdownDelegate>)delegate andContentSize:(CGSize)contentSize
{
    UIPopoverController* popover = [self dropdownPopoverControllerForDropdownDataSource:dataSource withDelegate:delegate];
    [popover setPopoverContentSize:contentSize];
    
    return popover;
}

+ (UIPopoverController*)dropdownPopoverControllerForDropdownDataSource:(DropdownDataSource*)dataSource withDelegate:(id<DropdownDelegate>)delegate
{
    DropdownController* controller = [[DropdownController alloc] initWithStyle:UITableViewStylePlain];
    controller.dataSource = dataSource;
    controller.delegate = delegate;
    UIPopoverController* popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    
    return popover;
}

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    if(_dataSource){
        [self setPreferredContentSize:[_dataSource getPreferedDropdownContentSize]];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(_dataSource && _dataSource.dropdownItems){
        return [_dataSource.dropdownItems count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    id object = [_dataSource.dropdownItems objectAtIndex:indexPath.row];
    NSString* title = _dataSource.titleForItemBlock(object);
    [cell.textLabel setText:title];
    [cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu-Medium" size:[[cell.textLabel font] pointSize]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_delegate && [_delegate respondsToSelector:@selector(dropdown:item:selectedAtIndex:fromDataSource:)]){
        if(_dataSource && _dataSource.dropdownItems){
            [_delegate dropdown:self item:[_dataSource.dropdownItems objectAtIndex:indexPath.row] selectedAtIndex:indexPath.row fromDataSource:_dataSource];
        }
    }
}

@end
