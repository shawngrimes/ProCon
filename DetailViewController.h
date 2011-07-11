//
//  DetailViewController.h
//  ProCon
//
//  Created by shawn on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "SummaryView.h"
//#import "MasterTableViewController.h"
#import "ProjectClass.h"
#import "ArgumentClass.h"

typedef enum {
    TAGButtonAddPro=20,
    TAGButtonAddCon,
} TAGButtons;

@class AppDelegate_Shared;
@class MasterTableViewController;

@interface DetailViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    UIBarButtonItem *decisionTitleBarButtonItem;
    
    UISegmentedControl *proConSegmentControl;
    UIButton *addProButton;
    UIButton *addConButton;
    UIButton *saveButton;
    UIPickerView *scorePicker;
    UITextField *argumentTextField;
    
    UIButton *reviewResultsButton;
    
    UIView *addArgumentView;
    
    UIView *selectDecisionView;
    UILabel *selectDecisionLabel;
    
    ProjectClass *selectedProject;
    MasterTableViewController *masterVC;
    
    UILabel *argumentCountLabel;
    
    UIView *argumentConfirmationView;
    UILabel *argumentConfirmationLabel;
    
}
@property (nonatomic, retain) IBOutlet UILabel *selectDecisionLabel;

@property (nonatomic, retain) IBOutlet UILabel *argumentConfirmationLabel;

@property (nonatomic, retain) IBOutlet UIView *argumentConfirmationView;

@property (nonatomic, retain) IBOutlet UILabel *argumentCountLabel;

@property (nonatomic, retain) IBOutlet MasterTableViewController *masterVC;

@property (nonatomic, retain) ProjectClass *selectedProject;

@property (nonatomic, retain) IBOutlet UIView *selectDecisionView;

@property (nonatomic, retain) IBOutlet UIView *addArgumentView;

@property (nonatomic, retain) IBOutlet UITextField *argumentTextField;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *decisionTitleBarButtonItem;
@property (nonatomic, retain) IBOutlet UISegmentedControl *proConSegmentControl;
@property (nonatomic, retain) IBOutlet UIButton *addProButton;
@property (nonatomic, retain) IBOutlet UIButton *addConButton;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UIPickerView *scorePicker;
@property (nonatomic, retain) IBOutlet UIButton *reviewResultsButton;

-(IBAction) addArgument:(id) sender;
-(IBAction) saveArgument:(id)sender;
-(void) clearValuesAndHideArgumentDetails;
-(IBAction) showSummary:(id) sender;
@end
