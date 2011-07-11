//
//  DetailViewController.m
//  ProCon
//
//  Created by shawn on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"


@implementation DetailViewController

@synthesize decisionTitleBarButtonItem;
@synthesize proConSegmentControl;
@synthesize addProButton;
@synthesize addConButton;
@synthesize saveButton;
@synthesize scorePicker;
@synthesize reviewResultsButton;
@synthesize argumentTextField;

@synthesize addArgumentView;
@synthesize selectedProject;
@synthesize masterVC;
@synthesize selectDecisionView;

@synthesize argumentCountLabel;
@synthesize argumentConfirmationView;
@synthesize argumentConfirmationLabel;
@synthesize selectDecisionLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
    [selectDecisionLabel release];
    [argumentConfirmationLabel release];
    [argumentConfirmationView release];
    [argumentCountLabel release];
    [selectDecisionView release];
    [masterVC release];
    [argumentTextField release];
    [addArgumentView release];
    [decisionTitleBarButtonItem release];
    [proConSegmentControl release];
    [addProButton release];
    [addConButton release];
    [saveButton release];
    [scorePicker release];
    [reviewResultsButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
	
}

#pragma mark -
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return 10;
}

#pragma mark -
#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	switch (self.proConSegmentControl.selectedSegmentIndex) {
		case 0:
			return [NSString stringWithFormat:@"+%i", row+1];
			break;
		case 1:
			return [NSString stringWithFormat:@"-%i", row+1];
		default:
			[NSException exceptionWithName:@"Data Picker Error" reason:@"Error with selectedSegmentIndex" userInfo:nil];
			break;
	}
	
	return @"";
	
}

#pragma mark - IBActions
-(IBAction) addArgument:(id) sender{
    
    //Save current argument if there is one
    if(self.addArgumentView.alpha>0){
        if(![self.argumentTextField.text isEqualToString:@""]){
            
                // TODO: Create new argument object
            [self saveArgument:sender];
            
            
            //Save argument:
            
        }
    }
    UIButton *tempButton=(UIButton *)sender;
    switch (tempButton.tag) {
        case TAGButtonAddPro:
//            NSLog(@"Add Pro Selected");
            self.proConSegmentControl.selectedSegmentIndex=0;
            [self.scorePicker reloadAllComponents];
            [UIView animateWithDuration:1.0f 
                             animations:^{
                                 self.addArgumentView.alpha=1.0f;
                             }
             ];

            break;
        case TAGButtonAddCon:
//            NSLog(@"Add con selected");
            self.proConSegmentControl.selectedSegmentIndex=1;
            [self.scorePicker reloadAllComponents];
            [UIView animateWithDuration:1.0f 
                             animations:^{
                                 self.addArgumentView.alpha=1.0f;
                             }
             ];

            break;
        default:
            [self clearValuesAndHideArgumentDetails];
            break;
    }

    
}

-(IBAction) saveArgument:(id)sender{
    if(![self.argumentTextField.text isEqualToString:@""]){
        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        ArgumentClass *selectedArgument=(ArgumentClass *)[NSEntityDescription insertNewObjectForEntityForName:@"Argument" inManagedObjectContext:[appDelegate managedObjectContext]];
        selectedArgument.argDescription=self.argumentTextField.text;
        selectedArgument.score=[NSNumber numberWithInt:([self.scorePicker selectedRowInComponent:0]+1)];
        switch (self.proConSegmentControl.selectedSegmentIndex) {
            case 0:
                selectedArgument.score=[NSNumber numberWithInt:abs([selectedArgument.score integerValue])];
                break;
            case 1:
                selectedArgument.score=[NSNumber numberWithInt:-1*abs([selectedArgument.score integerValue])];
            default:
                [NSException exceptionWithName:@"Data Picker Error" reason:@"Error with selectedSegmentIndex" userInfo:nil];
                break;
        }
        selectedArgument.project=self.selectedProject;
        
        [UIView animateWithDuration:0.7
                              delay:0.5
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
//                             NSLog(@"Showing bookmarkStatusView");
                             //self.argumentConfirmationView.text=@"Argument Added";
                             self.argumentConfirmationView.alpha=0.8;
                             
                         }
                         completion:^(BOOL finished){
                           
                             [UIView animateWithDuration:0.7
                                                   delay:0.5
                                                 options:UIViewAnimationCurveEaseOut 
                                              animations:^{
//                                                  NSLog(@"Hiding bookmarkStatusView");
                                                  self.argumentConfirmationView.alpha=0.0;                                                    
                                              }
                                              completion:nil];
                            
                         }
         ];

        
        if([selectedArgument isUpdated]){
//            NSLog(@"Saving MOC");
            NSError *error = nil;
            if (![selectedArgument.managedObjectContext save:&error]) {
                [NSException exceptionWithName:@"Save Error" reason:@"Error saving argument" userInfo:nil];
            }
        }
    }
//	[self.navigationController popViewControllerAnimated:YES];
    
    [self clearValuesAndHideArgumentDetails];
	
}

-(IBAction) showSummary:(id) sender{
//    NSLog(@"Show Summary clicked");
    [self.masterVC showSummaryForProject:self.selectedProject];    
}

-(void)clearValuesAndHideArgumentDetails{
    self.argumentTextField.text=@"";
    [self.scorePicker reloadAllComponents];
    [self.scorePicker selectRow:0 inComponent:0 animated:NO];
    [UIView animateWithDuration:1.0f 
                     animations:^{
                         self.addArgumentView.alpha=0.0f;
                     }
     ];
    self.argumentCountLabel.text=[NSString stringWithFormat:@"%i Arguments", [self.selectedProject.arguments count]];
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.addArgumentView.alpha=0.0f;
    self.addProButton.tag=TAGButtonAddPro;
    self.addConButton.tag=TAGButtonAddCon;
    
    self.selectDecisionView.layer.cornerRadius = 10.0;
    self.selectDecisionView.layer.frame = CGRectInset(self.selectDecisionView.frame, 10, 10);
    self.selectDecisionLabel.frame=CGRectMake(0, 0, self.selectDecisionView.frame.size.width, self.selectDecisionView.frame.size.height-20);
    
    if(self.selectedProject==nil){
        self.addProButton.enabled=NO;
        self.addConButton.enabled=NO;
        self.reviewResultsButton.enabled=NO;
        [UIView animateWithDuration:1.0f 
                         animations:^{
                             self.selectDecisionView.alpha=0.8f;
                         }
         ];
    }
    
    self.argumentConfirmationView.alpha=0.0;
    self.argumentConfirmationView.layer.cornerRadius = 10.0;
    self.argumentConfirmationView.layer.frame = CGRectInset(self.argumentConfirmationView.frame, 10, 10);
    self.argumentConfirmationLabel.frame=CGRectMake(0, self.argumentConfirmationView.frame.size.height * 0.5f - 10.0, self.argumentConfirmationView.frame.size.width, 20);
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.decisionTitleBarButtonItem = nil;
    self.proConSegmentControl = nil;
    self.addProButton = nil;
    self.addConButton = nil;
    self.saveButton = nil;
    self.scorePicker = nil;
    self.reviewResultsButton = nil;
    self.addArgumentView = nil;
    self.argumentTextField = nil;
    self.masterVC = nil;
    self.selectDecisionView = nil;
    self.argumentCountLabel = nil;
    self.argumentConfirmationView = nil;
    self.argumentConfirmationLabel = nil;
    self.selectDecisionLabel = nil;



}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
