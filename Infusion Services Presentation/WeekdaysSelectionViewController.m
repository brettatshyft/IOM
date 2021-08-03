//
//  WeekdaysSelectionViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/10/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "WeekdaysSelectionViewController.h"
#import "IOMAnalyticsManager.h"

@interface WeekdaysSelectionViewController ()<IOMAnalyticsIdentifiable>{
    NSArray* _weeksDaysTitles;
    NSInteger _weekdayBitMask;
}

@end

@implementation WeekdaysSelectionViewController

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

    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setScrollEnabled:FALSE];
    _weekdayBitMask = [*_weekdaysSelectedMask integerValue];
    _weeksDaysTitles = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IOMAnalyticsManager shared] trackScreenView:self];
    [self preselectRows];
    [self setPreferredContentSize:CGSizeMake(320, 1000)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView updateConstraints];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //Set pointer to new bitmask on exit
    *_weekdaysSelectedMask = [NSNumber numberWithInteger:_weekdayBitMask];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)preselectRows
{
    if(_weekdayBitMask & Sunday){
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self checkRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }
    if(_weekdayBitMask & Monday){
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self checkRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    }
    if(_weekdayBitMask & Tuesday){
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self checkRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    }
    if(_weekdayBitMask & Wednesday){
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self checkRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    }
    if(_weekdayBitMask & Thursday){
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self checkRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
    }
    if(_weekdayBitMask & Friday){
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self checkRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:1]];
    }
    if(_weekdayBitMask & Saturday){
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self checkRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:1]];
    }
}

- (void)checkRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (void)uncheckRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) return 1;
    else return 7;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"weekdayCell";

    if (indexPath.section==1)
    {
        UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

        NSString* title = [_weeksDaysTitles objectAtIndex:indexPath.row];
        [cell.textLabel setText:title];
        cell.userInteractionEnabled=TRUE;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //UIView* backgroundview = [[UIView alloc] init];
        //backgroundview.backgroundColor = [UIColor clearColor];
        //backgroundview.layer.masksToBounds = YES;
        //backgroundview.layer.frame=CGRectMake(0,0,320,43);
        //cell.selectedBackgroundView = backgroundview;
        //[backgroundview.layer setMasksToBounds:YES];
        
        return cell;
    }
    else
    {
        UITableViewCell* cell = [[UITableViewCell alloc] init];
        
        UILabel *upperLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 320, 24)];
        upperLabel.text=@"Select the days of the week";
        upperLabel.textAlignment=NSTextAlignmentCenter;
        upperLabel.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:147.0/255.0 alpha:1.0];
        [cell addSubview:upperLabel];

        UILabel *lowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, 320, 24)];
        lowerLabel.text=@"you wish to change hours for:";
        lowerLabel.textAlignment=NSTextAlignmentCenter;
        lowerLabel.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:147.0/255.0 alpha:1.0];
        [cell addSubview:lowerLabel];
        
        //NSString* title = @"Help";
        [cell.textLabel setText:@""];
        cell.userInteractionEnabled=FALSE;
        
        /*UIView* backgroundview = [[UIView alloc] init];
        backgroundview.backgroundColor = [UIColor clearColor];
        backgroundview.layer.masksToBounds = YES;
        cell.selectedBackgroundView = backgroundview;*/
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            //Monday
            _weekdayBitMask |= Sunday;
            break;
        case 1:
            _weekdayBitMask |= Monday;
            break;
        case 2:
            _weekdayBitMask |= Tuesday;
            break;
        case 3:
            _weekdayBitMask |= Wednesday;
            break;
        case 4:
            _weekdayBitMask |= Thursday;
            break;
        case 5:
            _weekdayBitMask |= Friday;
            break;
        case 6:
            _weekdayBitMask |= Saturday;
            break;
            
        default:
            break;
    }
    
    [self checkRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            //Monday
            _weekdayBitMask &= ~Sunday;
            break;
        case 1:
            _weekdayBitMask &= ~Monday;
            break;
        case 2:
            _weekdayBitMask &= ~Tuesday;
            break;
        case 3:
            _weekdayBitMask &= ~Wednesday;
            break;
        case 4:
            _weekdayBitMask &= ~Thursday;
            break;
        case 5:
            _weekdayBitMask &= ~Friday;
            break;
        case 6:
            _weekdayBitMask &= ~Saturday;
            break;
            
        default:
            break;
    }
    
    [self uncheckRowAtIndexPath:indexPath];
}

-(NSString*)analyticsIdentifier
{
    return @"weekdays_selection";
}

@end
