//
//  IOMScenarioTableViewCell.m
//  Infusion Services Presentation
//
//  Created by Paul Jones on 2/1/18.
//  Copyright © 2018 Local Wisdom Inc. All rights reserved.
//

#import "IOMScenarioTableViewCell.h"

@interface IOMScenarioTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *simponiAriaContainer;
@property (weak, nonatomic) IBOutlet UIView *remicadeContainerView;
@property (weak, nonatomic) IBOutlet UIView *stelaraContainerView;

@end

@implementation IOMScenarioTableViewCell

- (void)setPresentationType:(PresentationType)type
{
    switch (type) {
        case PresentationTypeRAIOI: {
            // no stelara
            _simponiAriaContainer.hidden = NO;
            _remicadeContainerView.hidden = NO;
            _stelaraContainerView.hidden = YES;
            break;
        }
        case PresentationTypeGIIOI: {
            // no simponi
            _simponiAriaContainer.hidden = YES;
            _remicadeContainerView.hidden = NO;
            _stelaraContainerView.hidden = NO;
            break;
        }
        case PresentationTypeDermIOI: {
            // only remicade
            _simponiAriaContainer.hidden = YES;
            _remicadeContainerView.hidden = NO;
            _stelaraContainerView.hidden = YES;
            break;
        }
        case PresentationTypeHOPD:
        case PresentationTypeMixedIOI:
        case PresentationTypeOther:
        default: {
            _simponiAriaContainer.hidden = NO;
            _remicadeContainerView.hidden = NO;
            _stelaraContainerView.hidden = NO;
            break;
        }
    }
}

@end
