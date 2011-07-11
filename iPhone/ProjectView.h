//
//  ProjectView.h
//  ProCon
//
//  Created by shawn on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ProjectClass.h"
#import "ArgumentClass.h"
#import "ItemView.h"
#import "SummaryView.h"

@class AppDelegate_iPhone;
@class FlurryAPI;

@interface ProjectView : UIViewController <UITextFieldDelegate> {

	UIButton *addProButton;
	UIButton *addConButton;
	UIButton *reviewDecisionButton;
	
	UITextField *projectNameTextField;
	ProjectClass *selectedProject;
	
	
}

@property (nonatomic, retain) IBOutlet 	UIButton *addProButton;
@property (nonatomic, retain) IBOutlet UIButton *addConButton;
@property (nonatomic, retain) IBOutlet UIButton *reviewDecisionButton;

@property (nonatomic, retain) IBOutlet 	UITextField *projectNameTextField;

@property (nonatomic, retain) ProjectClass *selectedProject;

-(IBAction) addPro:(id)sender;
-(IBAction) addCon:(id)sender;
-(IBAction) reviewDecision:(id)sender;
-(IBAction) goBack:(id)sender;


@end
