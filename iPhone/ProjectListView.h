//
//  ProjectListView.h
//  ProCon
//
//  Created by shawn on 1/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ProjectView.h"
#import "ProjectClass.h"

@class FlurryAPI;

@class AppDelegate_Shared;
@class AppDelegate_iPhone;

@interface ProjectListView : UIViewController <UITableViewDelegate,NSFetchedResultsControllerDelegate> {
	UITableView *_projectsTableView;
	UIButton *_addButton;
    UIButton *_editButton;
	NSManagedObjectContext *_MOC;
	NSFetchedResultsController *_FRC;
	NSArray *_projectsArray;
	UILabel *_versionLabel;
    BOOL isEditing;
}

@property (nonatomic, retain) IBOutlet UILabel *versionLabel;

@property (nonatomic, retain) IBOutlet UITableView *projectsTableView;
@property (nonatomic, retain) IBOutlet UIButton *addButton;
@property (nonatomic, retain) IBOutlet UIButton *editButton;
@property (nonatomic, retain) NSManagedObjectContext *MOC;
@property (nonatomic, retain) NSFetchedResultsController *FRC;
@property (nonatomic, retain) NSArray *projectsArray;


-(IBAction)addProject:(id) sender;

@end
