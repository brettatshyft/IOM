//
//  SavedPresentationsViewController.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/20/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOMBackupManager.h"
#import <MessageUI/MessageUI.h>

@interface SavedPresentationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIAlertViewDelegate, IOMBackupManagerDelegate, MFMailComposeViewControllerDelegate>{
    
}

@end
