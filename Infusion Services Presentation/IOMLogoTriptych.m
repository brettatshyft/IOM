//
//  IOMLogoTriptych.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 12/14/17.
//  Copyright © 2017 Local Wisdom Inc. All rights reserved.
//

#import "IOMLogoTriptych.h"
#import "Presentation+Extension.h"
#import "GraphWebView.h"

@interface IOMLogoTriptych ()
@property (weak, nonatomic) IBOutlet UIImageView *remicadeLogo;
@property (weak, nonatomic) IBOutlet UIImageView *stelaraLogo;
@property (weak, nonatomic) IBOutlet UIImageView *simponiLogo;

@end

@implementation IOMLogoTriptych

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _stelaraLogo.hidden = ![_presentation includeStelara];
    _simponiLogo.hidden = ![_presentation includeSimponiAria];
}

@end
