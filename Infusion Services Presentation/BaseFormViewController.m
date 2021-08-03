//
//  BaseFormViewController.m
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 2/19/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import "BaseFormViewController.h"

@interface BaseFormViewController (){

}

@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray* inputBackgrounds;
@property (weak, nonatomic) UITextField *activeField;
@end

@implementation BaseFormViewController
//@synthesize context = _context;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initKeyboardAccessory];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _textFieldArray = nil;
    _activeField = nil;
}

/*- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
	[textField resignFirstResponder];
    
	return YES;
    
}*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    UITextField *next = self.textFieldArray[[self nextFieldIndex:textField]];
    if (next) {
        [next becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
}

- (int) nextFieldIndex:(UITextField *)textField {
    int currentIndex = [self.textFieldArray indexOfObject:textField];
    int nextIndex = currentIndex+1;
    if (nextIndex>=[self.textFieldArray count]) nextIndex=0;
    UITextField *next = self.textFieldArray[nextIndex];
    while (next.hidden==TRUE)
    {
        nextIndex++;
        if (nextIndex>=[self.textFieldArray count]) nextIndex=0;
        next = self.textFieldArray[nextIndex];
    }
    
    return nextIndex;
}

- (int) previousFieldIndex:(UITextField *)textField {
    int currentIndex = [self.textFieldArray indexOfObject:textField];
    int previousIndex = currentIndex-1;
    if (previousIndex<0) previousIndex=[self.textFieldArray count]-1;
    UITextField *previous = self.textFieldArray[previousIndex];
    while (previous.hidden==TRUE)
    {
        previousIndex--;
        if (previousIndex<0) previousIndex=[self.textFieldArray count]-1;
        previous = self.textFieldArray[previousIndex];
    }

    return previousIndex;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

- (void) toolbarPrevious
{
    if (self.activeField)
    {
        UITextField *previous = self.textFieldArray[[self previousFieldIndex:self.activeField]];
        [previous becomeFirstResponder];
    }
}

- (void) toolbarNext
{
    if (self.activeField)
    {
        UITextField *next = self.textFieldArray[[self nextFieldIndex:self.activeField]];
        [next becomeFirstResponder];
    }
}

- (void) toolbarDone
{
    if (self.activeField) {
        [self.activeField resignFirstResponder];
    }
}

- (void)initKeyboardAccessory
{
    UIToolbar * _keyboardAccessoryToolbar = [[UIToolbar alloc] init];
    
    _keyboardAccessoryToolbar.barStyle		= UIBarStyleDefault;
    _keyboardAccessoryToolbar.translucent	= YES;
    _keyboardAccessoryToolbar.tintColor	= [UIColor blackColor];
    _keyboardAccessoryToolbar.backgroundColor = [UIColor grayColor];
    
    [_keyboardAccessoryToolbar sizeToFit];
    
    //Arrow_03-1

    UIBarButtonItem* previousButtonArrow    = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Arrow_06-1.png"] style:UIBarButtonItemStyleBordered  target:self action:@selector(toolbarPrevious)];
    
    UIBarButtonItem* previousButton    = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered  target:self action:@selector(toolbarPrevious)];
    
    UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered  target:self action:@selector(toolbarNext)];
    
    UIBarButtonItem* nextButtonArrow    = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Arrow_06.png"] style:UIBarButtonItemStyleBordered  target:self action:@selector(toolbarNext)];
    
    UIBarButtonItem* doneButton    = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered  target:self action:@selector(toolbarDone)];
    
    UIBarButtonItem *spacer    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [_keyboardAccessoryToolbar setItems:[NSArray arrayWithObjects:previousButtonArrow, previousButton, nextButton, nextButtonArrow, spacer, doneButton, nil]];
    
    for(UITextField * thisTextField in self.textFieldArray) {
        thisTextField.inputAccessoryView = _keyboardAccessoryToolbar;
    }
    
    //return _keyboardAccessoryToolbar;
    
}



@end
