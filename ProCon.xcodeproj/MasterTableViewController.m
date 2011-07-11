//
//  MasterTableViewController.m
//  ProCon
//
//  Created by Shawn Grimes on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MasterTableViewController.h"


@implementation MasterTableViewController

@synthesize detailVC;
@synthesize MGSplitVC;
@synthesize addButton;
@synthesize MOC;
@synthesize FRC=_FRC;
@synthesize projectsArray;
@synthesize navController;
@synthesize appDelegate;
@synthesize decisionsTableView;


- (void)dealloc
{
    
    [decisionsTableView release];
    [navController release];
    [detailVC release];
    
    [MGSplitVC release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.MOC=[appDelegate managedObjectContext];
    if(self.MOC==nil){
//        NSLog(@"Stop here");
    }
    NSError *error;
	if (![self.FRC performFetch:&error]) {
		[NSException exceptionWithName:@"Error performing fetch" reason:@"error performing fetch" userInfo:nil];
	}
    [self.decisionsTableView reloadData];

    
    
    [self.MGSplitVC toggleMasterView:NO];
    [self.MGSplitVC setVertical:NO];
    [self.MGSplitVC setSplitPosition:300 animated:NO];
//    [self.MGSplitVC setSplitWidth:20];
//    NSLog(@"Edit Button: %@", self.editButtonItem);
//    self.parentViewController.navigationItem.leftBarButtonItem=self.editButtonItem;
    
//    [self.navController setEditing:YES];
//    [self.navController.navigationItem setLeftBarButtonItem:self.editButtonItem];
    self.MGSplitVC.navigationItem.leftBarButtonItem=self.editButtonItem;
//    self.navController.navigationItem.rightBarButtonItem=self.editButtonItem;
//    self.navigationItem.leftBarButtonItem=self.editButtonItem;
    addButton=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProject)] autorelease];
	self.MGSplitVC.navigationItem.rightBarButtonItem=addButton;
//	self.navigationItem.rightBarButtonItem=addButton;
//    self.navController.navigationItem.riBarButtonItem=addButton;
    
	
    
    newProjectName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 60.0)];


    self.title=@"Decisions to be made:";
    
    
//    [self.navigationController.toolbar setHidden:NO];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.detailVC = nil;
    self.MGSplitVC=nil;
    [newProjectName release];
    newProjectName=nil;
    self.navController = nil;
    
    appDelegate = nil;
    self.decisionsTableView = nil;


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	
	
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	[appDelegate saveContext];
    
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[self.FRC fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text=[[[self.FRC fetchedObjects] objectAtIndex:indexPath.row] valueForKey:@"projectName"];
	cell.detailTextLabel.text=[dateFormatter stringFromDate:[[[self.FRC fetchedObjects] objectAtIndex:indexPath.row] valueForKey:@"lastModified"]];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        // Delete the managed object at the given index path.
        ProjectClass *projectToDelete = [[self.FRC fetchedObjects] objectAtIndex:indexPath.row];
        [projectToDelete.managedObjectContext deleteObject:projectToDelete];
		
        // Update the array and table view.
        //[projectsArray removeObjectAtIndex:indexPath.row];
		
        // Commit the change.
        NSError *error = nil;
		if([projectToDelete.managedObjectContext hasChanges]){
			
//			NSLog(@"Saving after delete");
			if (![projectToDelete.managedObjectContext save:&error]) {
				[NSException exceptionWithName:@"Save Error" reason:@"Error deleting project" userInfo:nil];
			}
			if(![self.FRC performFetch:&error]){
				[NSException exceptionWithName:@"Fetch Error" reason:@"Fetch error after deleting project" userInfo:nil];
			}
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		}
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    ProjectClass *selectedProject=[[self.FRC fetchedObjects] objectAtIndex:indexPath.row];
	[self selectProject:selectedProject];
}

-(IBAction)addProject{
    
	
	
	    
    UIAlertView *prompt=[[UIAlertView alloc] initWithTitle:@"Describe your quandry:" message:@"\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    newProjectName.backgroundColor=[UIColor whiteColor];
    newProjectName.placeholder=@"Decision To Be Made";
    [prompt addSubview:newProjectName];
    [prompt show];
    [prompt release];
    [newProjectName becomeFirstResponder];
    
	
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
//            NSLog(@"Cancel button clicked");
            break;
        case 1 :
            NSLog(@"Save button clicked");
            
            ProjectClass *newProject = (ProjectClass *)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:self.FRC.managedObjectContext];
            /*
            if(![newProjectName.text isEqualToString:@""]){
                newProject.projectName=newProjectName.text;
            }else{
                newProject.projectName=@"New Decision";
            }
            */
            newProject.lastModified=[NSDate date];
            NSError *error = nil;
            if (![newProject.managedObjectContext save:&error]) {
                [NSException exceptionWithName:@"Save Error" reason:@"Error saving new project" userInfo:nil];
            }
            [self.FRC performFetch:nil];
            [self.decisionsTableView reloadData];
            [self selectProject:newProject];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - DetailViewController
-(void)selectProject:(ProjectClass *)chosenProject{
    self.detailVC.selectedProject=chosenProject;
    self.detailVC.decisionTitleBarButtonItem.title=chosenProject.projectName;
    self.detailVC.addProButton.enabled=YES;
    self.detailVC.addConButton.enabled=YES;
    self.detailVC.reviewResultsButton.enabled=YES;
    self.detailVC.selectDecisionView.alpha=0.0f;
    self.detailVC.argumentCountLabel.text=[NSString stringWithFormat:@"%i Arguments", [chosenProject.arguments count]];
    
}

-(void)showSummaryForProject:(ProjectClass *)chosenProject{
    SummaryView *summaryVC = [[SummaryView alloc] initWithNibName:@"SummaryView-iPad" bundle:nil];
    summaryVC.selectedProject=chosenProject;
    [self.navController pushViewController:summaryVC animated:YES];
    [summaryVC release];

    
    
}


#pragma mark - FRC
- (NSFetchedResultsController *)FRC {
	if(_FRC!=nil){
		return _FRC;
	}
	
	NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
	
//	AppDelegate_Shared *appDelegate=(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//	NSManagedObjectContext *managedObjectContext=[appDelegate managedObjectContext];
	
//    NSLog(@"Delegate: %@", [UIApplication sharedApplication].delegate );
    
//   AppDelegate_Shared *_appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
//    self.MOC=_appDelegate.managedObjectContext;
//    NSLog(@"MOC: %@", self.MOC);
	NSEntityDescription *entity=[NSEntityDescription entityForName:@"Project" inManagedObjectContext:self.MOC];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:20];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"projectName" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] 
									   initWithFetchRequest:fetchRequest 
									   managedObjectContext:self.MOC 
									   sectionNameKeyPath:@"projectName"
									   cacheName:nil];
	frc.delegate=self;
	[frc performFetch:nil];
//	NSLog(@"Fetched %i objects", [[frc fetchedObjects]count]);
	_FRC=frc;
	[fetchRequest release];
	return _FRC;
}


#pragma mark -
#pragma mark SplitView


@end
