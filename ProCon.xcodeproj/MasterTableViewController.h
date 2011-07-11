//
//  MasterTableViewController.h
//  ProCon
//
//  Created by Shawn Grimes on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DetailViewController.h"
#import "MGSplitViewController.h"
#import "SummaryView.h"
//#import "AppDelegate_iPad.h"

@class AppDelegate_iPad;

@interface MasterTableViewController : UIViewController <MGSplitViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,UIAlertViewDelegate> {
    DetailViewController *detailVC;
    MGSplitViewController *MGSplitVC;
    UIBarButtonItem *addButton;
    NSManagedObjectContext *MOC;
    NSFetchedResultsController *_FRC;
    NSArray *projectsArray;
    
    UITextField *newProjectName;
    UINavigationController *navController;
    
    UITableView *decisionsTableView;
    
    AppDelegate_iPad *appDelegate;
    
}
@property (nonatomic, retain) IBOutlet UITableView *decisionsTableView;

@property (nonatomic, assign) IBOutlet AppDelegate_iPad *appDelegate;

@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@property (nonatomic, retain) IBOutlet DetailViewController *detailVC;
@property (nonatomic, retain) IBOutlet MGSplitViewController *MGSplitVC;

@property (nonatomic, retain) 	UIBarButtonItem *addButton;
@property (nonatomic, retain) 	NSManagedObjectContext *MOC;
@property (nonatomic, retain) 	NSFetchedResultsController *FRC;
@property (nonatomic, retain) 	NSArray *projectsArray;

-(IBAction) addProject;
-(void) selectProject:(ProjectClass *)chosenProject;
-(void) showSummaryForProject:(ProjectClass *)chosenProject;

@end
