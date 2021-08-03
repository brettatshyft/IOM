//
//  AppDelegate.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/15/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "Colors.h"
#import "IOMMyInfoManager.h"
#import "IOMSyncManager.h"
#import "IOMAnalyticsManager.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#define PRESENTATION_ORDER_NUMBER_KEY @"presentation_order_key"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setBarTintColor:[[Colors getInstance] defaultBackgroundColor]];

    [Fabric with:@[[Crashlytics class], [Answers class]]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];

    [[IOMAnalyticsManager shared] trackDidFinishLaunching];

    BOOL myInfoExists = [[[IOMMyInfoManager alloc] init] checkForMyInfo];
    
    if (myInfoExists)
    {
        [[[IOMSyncManager alloc] init] sendSyncIfRequired];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    BOOL myInfoExists = [[[IOMMyInfoManager alloc] init] checkForMyInfo];
    
    if (myInfoExists)
    {
        [[[IOMSyncManager alloc] init] sendSyncIfRequired];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}

#pragma mark - Presentaion Order
- (NSNumber* )getPresentationOrderNumber{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* currentOrderNumber = [userDefaults objectForKey:PRESENTATION_ORDER_NUMBER_KEY];
    if(!currentOrderNumber){
        currentOrderNumber = [NSNumber numberWithInt:0];
    }
    [userDefaults setObject:[NSNumber numberWithInt:([currentOrderNumber intValue] + 1)] forKey:PRESENTATION_ORDER_NUMBER_KEY];
    return currentOrderNumber;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        
        //Undo Support
    	NSUndoManager *anUndoManager = [[NSUndoManager	alloc] init];
    	[_managedObjectContext setUndoManager:anUndoManager];
//        _managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
//        _managedObjectContext.automaticallyMergesChangesFromParent = YES;
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Infusion_Services_Presentation" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Infusion_Services_Presentation.sqlite"];
    
    NSMutableDictionary *pragmaOptions = [NSMutableDictionary dictionary];
    [pragmaOptions setObject:@"DELETE" forKey:@"journal_mode"];
    
    //Set flags for Core Data automatic migration to true (migrating to latest version of core data model).
    NSDictionary* persistentStoreOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                                            pragmaOptions, NSSQLitePragmasOption, nil];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:persistentStoreOptions error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - CoreData Save Notification
- (void)contextDidSaveNotification:(NSNotification *)notification
{
    NSManagedObjectContext *savedContext = [notification object];
    
    // ignore change notifications for the main MOC
    if ([self managedObjectContext] == savedContext)
    {
        return;
    }
    
    if ([self managedObjectContext].persistentStoreCoordinator != savedContext.persistentStoreCoordinator)
    {
        // that's another database
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [[self managedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
        NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Presentation"];
        NSError * error = nil;
        NSArray *presentationsArray = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (presentationsArray.count > 0){
            Presentation *presentation = (Presentation*)[presentationsArray objectAtIndex:0];
            if (presentation.scenarios.count > 0){
                Scenario *scenario = (Scenario*) [[presentation.scenarios allObjects] objectAtIndex:0];
                NSLog(@"%@",scenario);
                NSLog(@"%@",presentation);
            }
        }
        NSArray *persistenStores = self.managedObjectContext.persistentStoreCoordinator.persistentStores;
        NSLog(@"%@",persistenStores);
        NSLog(@"%@",[persistenStores objectAtIndex:0]);
//
//        if (((NSManagedObjectContext*) notification).persistentStoreCoordinator){
//            NSArray *tempStores = ((NSManagedObjectContext*) notification).persistentStoreCoordinator.persistentStores;
//            NSLog(@"%@",tempStores);
//            NSLog(@"%@",[tempStores objectAtIndex:0]);
//        }

    });
}

@end
