//
//  IOMMyInfoManager.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 2/12/15.
//  Copyright (c) 2015 Local Wisdom Inc. All rights reserved.
//

#import "IOMMyInfoManager.h"
#import "UIAlertView+Block.h"
#import "NSUserDefaults+IOMMyInfoUserDefaults.h"

@interface NSString (Validation)

- (BOOL) isValidEmail;
- (BOOL) isValidRDT;
- (BOOL) isValidWWID;

@end

@implementation NSString (Validation)

- (BOOL)isValidEmail
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidRDT
{
    return [[self stringByReplacingOccurrencesOfString:@"-" withString:@""] length] == 7;
}

- (BOOL)isValidWWID
{
    return [self rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound;
}

@end

@implementation IOMMyInfoManager

- (BOOL)checkForMyInfo
{
    BOOL myInfoExists = NO;
    
    NSDictionary * myInfoDictionary = [NSUserDefaults iom_getMyInfoUserDefault];
    
    if ([myInfoDictionary count] == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"My Info" message:@"Please enter some information about yourself." cancelButtonTitle:@"Okay"];
        
        [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self showEmailAlertBecauseInvalid:NO withInitialText:@"" toContinue:YES];
        }];
    }
    
    else
    {
        myInfoExists = YES;
    }
    
    return myInfoExists;
}

+ (NSString *)email
{
    NSDictionary * myInfoDictionary = [NSUserDefaults iom_getMyInfoUserDefault];
    return [myInfoDictionary objectForKey:IOMMyInfoManagerKeyEmail];
}

+ (NSString *)rdt
{
    NSDictionary * myInfoDictionary = [NSUserDefaults iom_getMyInfoUserDefault];
    return [myInfoDictionary objectForKey:IOMMyInfoManagerKeyRDT];
}

+ (NSString *)wwid
{
    NSDictionary * myInfoDictionary = [NSUserDefaults iom_getMyInfoUserDefault];
    return [myInfoDictionary objectForKey:IOMMyInfoManagerKeyWWID];
}

- (void)showMyInfoAlert
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"My Info" message:@"What info would you like to edit?" cancelButtonTitle:@"Cancel"];
    
    NSString * email = [NSUserDefaults iom_getMyInfoUserDefaultForType:IOMMyInfoDefaultsEmail];
    NSString * rdt = [NSUserDefaults iom_getMyInfoUserDefaultForType:IOMMyInfoDefaultsRDT];
    NSString * wwid = [NSUserDefaults iom_getMyInfoUserDefaultForType:IOMMyInfoDefaultsWWID];
    
    [alert addButtonWithTitle:[NSString stringWithFormat:@"Email: %@", email]];
    [alert addButtonWithTitle:[NSString stringWithFormat:@"RDT: %@", rdt]];
    [alert addButtonWithTitle:[NSString stringWithFormat:@"WWID: %@", wwid]];
    
    [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 1:
                [self showEmailAlertBecauseInvalid:NO withInitialText:email toContinue:NO];
                break;
                
            case 2:
                [self showRDTAlertBecauseInvalid:NO withInitialText:rdt toContinue:NO];
                break;
                
            case 3:
                [self showWWIDAlertBecauseInvalid:NO withInitialText:wwid toContinue:NO];
                break;
                
            default:
                break;
        }
    }];
}

- (void)showEmailAlertBecauseInvalid:(BOOL)becauseInvalid withInitialText:(NSString *)initialText toContinue:(BOOL)toContinue
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"My Info"
                                                     message:becauseInvalid ? @"Please enter a valid email." : @"Please enter your email address."
                                             cancelButtonTitle:@"Done"];
    
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setPlaceholder:@"youremail@provider.com"];
    [[alert textFieldAtIndex:0] setText:initialText];
    
    [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        NSString * email = [[alertView textFieldAtIndex:0] text];
        
        if ([email isValidEmail])
        {
            [NSUserDefaults iom_setMyInfoUserDefaultWithString:email forType:IOMMyInfoDefaultsEmail];
            
            if (toContinue)
            {
                [self showRDTAlertBecauseInvalid:NO withInitialText:@"" toContinue:toContinue];
            }
        }
        else
        {
            [self showEmailAlertBecauseInvalid:YES withInitialText:email toContinue:toContinue];
        }
        
    }];
}

- (void)showRDTAlertBecauseInvalid:(BOOL)becauseInvalid withInitialText:(NSString *)initialText toContinue:(BOOL)toContinue
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"My Info"
                                                     message:becauseInvalid ? @"Please enter a valid RDT." : @"Please enter your RDT."
                                           cancelButtonTitle:@"Done"];
    
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setPlaceholder:@"00-000-00"];
    [[alert textFieldAtIndex:0] setText:initialText];
    
    [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        NSString * rdt = [[alertView textFieldAtIndex:0] text];
        
        if ([rdt isValidRDT])
        {
            [NSUserDefaults iom_setMyInfoUserDefaultWithString:rdt forType:IOMMyInfoDefaultsRDT];
            
            if (toContinue)
            {
                [self showWWIDAlertBecauseInvalid:NO withInitialText:@"" toContinue:YES];
            }
        }
        else
        {
            [self showRDTAlertBecauseInvalid:YES withInitialText:rdt toContinue:toContinue];
        }
        
    }];
}

- (void)showWWIDAlertBecauseInvalid:(BOOL)becauseInvalid withInitialText:(NSString *)initialText toContinue:(BOOL)toContinue
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"My Info"
                                                     message:becauseInvalid ? @"Please enter a valid WWID." : @"Please enter your WWID."
                                           cancelButtonTitle:@"Done"];
    
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setPlaceholder:@"000000000"];
    [[alert textFieldAtIndex:0] setText:initialText];
    
    [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        NSString * wwid = [[alertView textFieldAtIndex:0] text];
        
        if ([wwid isValidWWID])
        {
            [NSUserDefaults iom_setMyInfoUserDefaultWithString:wwid forType:IOMMyInfoDefaultsWWID];
            
            if (toContinue)
            {
                [self showThankYou];
            }
        }
        else if (![wwid isValidWWID])
        {
            [self showWWIDAlertBecauseInvalid:YES withInitialText:wwid toContinue:toContinue];
        }
        
    }];
}

- (void)showThankYou
{
    [[[UIAlertView alloc] initWithTitle:@"Thank You!"
                               message:@"Thank you for entering your information."
                     cancelButtonTitle:@"Okay"] show];
}

@end
