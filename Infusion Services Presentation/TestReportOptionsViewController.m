//
//  TestReportOptionsViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 1/27/14.
//  Copyright (c) 2014 Local Wisdom Inc. All rights reserved.
//

#import "TestReportOptionsViewController.h"
#import "Scenario+Extension.h"
#import "Chair+Extension.h"
#import "Staff+Extension.h"
#import "RemicadeInfusion+Extension.h"
#import "SimponiAriaInfusion+Extension.h"
#import "OtherInfusion+Extension.h"
#import "OtherInjection+Extension.h"
#import "SolutionData+Extension.h"
#import "AppDelegate.h"
#import "TestReportDisplayViewController.h"
#import "ScenarioReportOverlayViewController.h"
#import "ScenarioOverviewViewController.h"
#import "PDFGeneratorViewController.h"
#import "TestWebMemoryViewController.h"
#import "Presentation+Extension.h"

@interface TestReportOptionsViewController (){
    NSManagedObjectContext* _context;
    Scenario* _scenario;
    
    UIStoryboard* _scenarioStoryboard;
}

@end

@implementation TestReportOptionsViewController

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
    
    _scenarioStoryboard = [UIStoryboard storyboardWithName:@"ScenariosStoryboard" bundle:[NSBundle mainBundle]];
    
    // Do any additional setup after loading the view from its nib.
    AppDelegate* appDel = [[UIApplication sharedApplication] delegate];
    _context = [appDel managedObjectContext];
    
    _scenario = [self createSolutionTestData:_context];
    NSError* error = nil;
    if (![_context save:&error]) {
        NSLog(@"Failed to save main context: %@", error);
    }
    
    //process solution data
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    [SolutionData processSolutionDataForScenario:_scenario];
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval diff = end - start;
    
    NSLog(@"Solution processing time ms: %f", diff * 1000);
    
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ganttSelected:(id)sender
{
    TestReportDisplayViewController * test = [[TestReportDisplayViewController alloc] init];
    test.schedule = YES;
    test.scenario = _scenario;
    
    [self.navigationController pushViewController:test animated:YES];
}

- (IBAction)barSelected:(id)sender
{
    TestReportDisplayViewController * test = [[TestReportDisplayViewController alloc] init];
    test.outSummary = YES;
    test.scenario = _scenario;
    
    [self.navigationController pushViewController:test animated:YES];
}

- (IBAction)testOverlay:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES];
    ScenarioReportOverlayViewController * overlay = [[ScenarioReportOverlayViewController alloc] init];
    overlay.scenario = _scenario;
    
    [self.navigationController pushViewController:overlay animated:NO];
}

- (IBAction)overview:(id)sender
{
    ScenarioOverviewViewController* overview = [_scenarioStoryboard instantiateViewControllerWithIdentifier:@"scenarioOverview"];
    [self.navigationController pushViewController:overview animated:NO];
}

- (IBAction)PDFView:(id)sender
{
    PDFGeneratorViewController* pdfGen = [[PDFGeneratorViewController alloc] init];
    pdfGen.scenario = _scenario;
    [self.navigationController pushViewController:pdfGen animated:YES];
}

- (IBAction)webviewTest:(id)sender
{
    TestWebMemoryViewController* testWeb = [[TestWebMemoryViewController alloc] init];
    testWeb.scenario = _scenario;
    [self.navigationController pushViewController:testWeb animated:YES];
}

- (Scenario*)createSolutionTestData:(NSManagedObjectContext*)context
{
    Presentation *presentation = [NSEntityDescription insertNewObjectForEntityForName:@"Presentation" inManagedObjectContext:context];
    presentation.accountName = @"Test PRes";
    presentation.presentationDate = [NSDate date];
    presentation.presentationsIncluded = [NSNumber numberWithInteger:PresentationSectionsIncludedTypeInfusionOptimization];
    presentation.presentationTypeID = [NSNumber numberWithInteger:PresentationTypeGIIOI];
    
    //Create Scenario
    Scenario* scenario = [Scenario createScenarioForPresentation:presentation]; //[NSEntityDescription insertNewObjectForEntityForName:@"Scenario" inManagedObjectContext:context];
    scenario.name = @"Test Scenario";
    scenario.maxChairsPerStaff = @4;
    scenario.dateCreated = [NSDate date];
    
    NSDateFormatter* timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h:mm a"];
    
    //Create Chairs
    NSString* startChairString = @"8:30 AM";
    NSString* endChairString = @"5:00 PM";
    for (int i = 0; i < 3; i++) {
        //Three chairs
        Chair* chair1 = [Chair createChairEntityForScenario:scenario];
        chair1.startTime0 = nil;
        chair1.startTime1 = [timeFormatter dateFromString:startChairString];
        chair1.startTime2 = [timeFormatter dateFromString:startChairString];
        chair1.startTime3 = [timeFormatter dateFromString:startChairString];
        chair1.startTime4 = [timeFormatter dateFromString:startChairString];
        chair1.startTime5 = [timeFormatter dateFromString:startChairString];
        chair1.startTime6 = nil;
        chair1.endTime0 = nil;
        chair1.endTime1 = [timeFormatter dateFromString:endChairString];
        chair1.endTime2 = [timeFormatter dateFromString:endChairString];
        chair1.endTime3 = [timeFormatter dateFromString:endChairString];
        chair1.endTime4 = [timeFormatter dateFromString:endChairString];
        chair1.endTime5 = [timeFormatter dateFromString:endChairString];
        chair1.endTime6 = nil;
    }
    
    //Create staff
    NSString* startStaffString = @"8:30 AM";
    NSString* endStaffString = @"5:00 PM";
    NSString* startBreakString = @"12:00 PM";
    NSString* endBreakString = @"12:30 PM";
    
    for (int i = 0; i < 5; i++) {
        //five staff
        Staff * staff = [Staff createStaffEntityForScenario:scenario];
        staff.workStartTime0 = nil;
        staff.workStartTime1 = [timeFormatter dateFromString:startStaffString];
        staff.workStartTime2 = [timeFormatter dateFromString:startStaffString];
        staff.workStartTime3 = [timeFormatter dateFromString:startStaffString];
        staff.workStartTime4 = [timeFormatter dateFromString:startStaffString];
        staff.workStartTime5 = [timeFormatter dateFromString:startStaffString];
        staff.workStartTime6 = nil;
        staff.workEndTime0 = nil;
        staff.workEndTime1 = [timeFormatter dateFromString:endStaffString];
        staff.workEndTime2 = [timeFormatter dateFromString:endStaffString];
        staff.workEndTime3 = [timeFormatter dateFromString:endStaffString];
        staff.workEndTime4 = [timeFormatter dateFromString:endStaffString];
        staff.workEndTime5 = [timeFormatter dateFromString:endStaffString];
        staff.workEndTime6 = nil;
        staff.breakStartTime0 = nil;
        staff.breakStartTime1 = [timeFormatter dateFromString:startBreakString];
        staff.breakStartTime2 = [timeFormatter dateFromString:startBreakString];
        staff.breakStartTime3 = [timeFormatter dateFromString:startBreakString];
        staff.breakStartTime4 = [timeFormatter dateFromString:startBreakString];
        staff.breakStartTime5 = [timeFormatter dateFromString:startBreakString];
        staff.breakStartTime6 = nil;
        staff.breakEndTime0 = nil;
        staff.breakEndTime1 = [timeFormatter dateFromString:endBreakString];
        staff.breakEndTime2 = [timeFormatter dateFromString:endBreakString];
        staff.breakEndTime3 = [timeFormatter dateFromString:endBreakString];
        staff.breakEndTime4 = [timeFormatter dateFromString:endBreakString];
        staff.breakEndTime5 = [timeFormatter dateFromString:endBreakString];
        staff.breakEndTime6 = nil;
        
        if(i < 3) {
            staff.staffTypeID = [NSNumber numberWithInteger:StaffTypeQHP];
        } else {
            staff.staffTypeID = [NSNumber numberWithInteger:StaffTypeAncillary];
        }
    }
    
    //Remicade inputs
    RemicadeInfusion* infusion = [RemicadeInfusion getRemicadeInfusionForScenario:scenario];
    infusion.prepTime = @2;
    infusion.postTime = @3;
    infusion.prepAncillary = @YES;
    infusion.postAncillary = @YES;
    infusion.avgInfusionsPerMonth = @27;
    infusion.avgNewPatientsPerMonthQ6 = @4;
    infusion.avgNewPatientsPerMonthQ8 = @6;
    
    infusion.percent2hr = @20;
    infusion.percent2_5hr = @20;
    infusion.percent3hr = @30;
    infusion.percent3_5hr = @10;
    infusion.percent4hr = @20;
    
    //Simponi default
    SimponiAriaInfusion* simp = [SimponiAriaInfusion getSimponiAriaInfusionForScenario:scenario];
    
    //Other infusions
    OtherInfusion * infusionA = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxA forScenario:scenario];
    OtherInfusion * infusionB = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxB forScenario:scenario];
    OtherInfusion * infusionC = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxC forScenario:scenario];
    OtherInfusion * infusionD = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxD forScenario:scenario];
    OtherInfusion * infusionE = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxE forScenario:scenario];
    OtherInfusion * infusionF = [OtherInfusion getOtherInfusionOfType:OtherInfusionTypeRxF forScenario:scenario];
    //A
    infusionA.treatmentsPerMonth = @10;
    infusionA.prepTime = @2;
    infusionA.infusionTime = @3;
    infusionA.postTime = @2;
    infusionA.avgNewPatientsPerMonth = @2;
    infusionA.weeksBetween = @2;
    //B
    infusionB.treatmentsPerMonth = @15;
    infusionB.prepTime = @2;
    infusionB.infusionTime = @6;
    infusionB.postTime = @2;
    infusionB.avgNewPatientsPerMonth = @4;
    infusionB.weeksBetween = @4;
    //C
    infusionC.treatmentsPerMonth = @5;
    infusionC.prepTime = @2;
    infusionC.infusionTime = @12;
    infusionC.postTime = @2;
    infusionC.avgNewPatientsPerMonth = @1;
    infusionC.weeksBetween = @6;
    //D
    infusionD.treatmentsPerMonth = @6;
    infusionD.prepTime = @2;
    infusionD.infusionTime = @18;
    infusionD.postTime = @2;
    infusionD.avgNewPatientsPerMonth = @2;
    infusionD.weeksBetween = @8;
    //E
    infusionE.treatmentsPerMonth = @10;
    infusionE.prepTime = @2;
    infusionE.infusionTime = @25;
    infusionE.postTime = @2;
    infusionE.avgNewPatientsPerMonth = @1;
    infusionE.weeksBetween = @26;
    //F
    infusionF.treatmentsPerMonth = @16;
    infusionF.prepTime = @2;
    infusionF.infusionTime = @31;
    infusionF.postTime = @2;
    infusionF.avgNewPatientsPerMonth = @3;
    infusionF.weeksBetween = @52;
    
    //Other injection
    OtherInjection* injection1 = [OtherInjection getOtherInjectionOfType:OtherInjectionType1 forScenario:scenario];
    OtherInjection* injection2 = [OtherInjection getOtherInjectionOfType:OtherInjectionType2 forScenario:scenario];
    //1
    injection1.treatmentsPerMonth = @10;
    injection2.treatmentsPerMonth = @15;
    
    return scenario;
}

@end
