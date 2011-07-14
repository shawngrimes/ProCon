//
//  ProjectView.m
//  ProCon
//
//  Created by shawn on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProjectView.h"


@implementation ProjectView
@synthesize projectNameTextField;

@synthesize selectedProject;

@synthesize addProButton,addConButton,reviewDecisionButton;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title=@"Decision View";
	[super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
	self.projectNameTextField.text=selectedProject.projectName;

//	NSLog(@"Selected Project: %@", selectedProject);
	
	[super viewDidAppear:animated];
	
}

-(void)viewWillDisappear:(BOOL)animated{
//	selectedProject.projectName=self.projectNameTextField.text;
//	selectedProject.lastModified=[NSDate date];
	// Commit the change.
	
//	NSError *error = nil;
//	if (![[selectedProject managedObjectContext] save:&error]) {
//		[NSException exceptionWithName:@"Save Error" reason:@"Error deleting project" userInfo:nil];
//	}
	
	selectedProject.projectName=self.projectNameTextField.text;
	selectedProject.lastModified=[NSDate date];
	
	
//	NSLog(@"Updated Project: %@", self.selectedProject);
	
	[selectedProject.managedObjectContext processPendingChanges];
	
	if([selectedProject isUpdated]){
//		NSLog(@"Saving MOC");
		NSError *error = nil;
		if (![selectedProject.managedObjectContext save:&error]) {
			[NSException exceptionWithName:@"Save Error" reason:@"Error deleting project" userInfo:nil];
		}
	}	
	
	[super viewWillDisappear:animated];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark -
#pragma mark IBActions
-(IBAction) addPro:(id)sender{
    [AppDelegate_iPhone clickSoundEffect];
    [FlurryAPI logEvent:@"PRO_ADDED"];
	ItemView *itemVC=[[ItemView alloc] init];
	ArgumentClass *newArgument=	(ArgumentClass *)[NSEntityDescription 
												 insertNewObjectForEntityForName:@"Argument" 
												 inManagedObjectContext:self.selectedProject.managedObjectContext];
	newArgument.project=self.selectedProject;
//	newArgument.argDescription=@"New Pro Description";
	newArgument.score=[NSNumber numberWithInt:1];
	itemVC.selectedArgument=newArgument;
	itemVC.proConSegment.selectedSegmentIndex=0;
	[self.navigationController pushViewController:itemVC animated:YES];
	
}
-(IBAction) addCon:(id)sender{
    [AppDelegate_iPhone clickSoundEffect];
    [FlurryAPI logEvent:@"CON_ADDED"];
	ItemView *itemVC=[[ItemView alloc] init];
	ArgumentClass *newArgument=	(ArgumentClass *)[NSEntityDescription 
												 insertNewObjectForEntityForName:@"Argument" 
												 inManagedObjectContext:self.selectedProject.managedObjectContext];
	newArgument.project=self.selectedProject;
//	newArgument.argDescription=@"New Con Description";
	newArgument.score=[NSNumber numberWithInt:-1];
	itemVC.selectedArgument=newArgument;
	itemVC.proConSegment.selectedSegmentIndex=1;
	[self.navigationController pushViewController:itemVC animated:YES];
}
-(IBAction) reviewDecision:(id)sender{
    [AppDelegate_iPhone clickSoundEffect];
    [FlurryAPI logEvent:@"DECISION_REVIEWED"];
	SummaryView *summaryVC = [[SummaryView alloc] init];
	summaryVC.selectedProject = self.selectedProject;
	
	[self.navigationController pushViewController:summaryVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
	
}

-(IBAction) goBack:(id)sender{
    [AppDelegate_iPhone clickSoundEffect];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Dealloc
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    self.addProButton=nil;
	self.addConButton=nil;
	self.reviewDecisionButton=nil;
	self.projectNameTextField=nil;


	[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	
}




@end
