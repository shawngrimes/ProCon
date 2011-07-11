//
//  ProjectListView.m
//  ProCon
//
//  Created by shawn on 1/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProjectListView.h"


@implementation ProjectListView

@synthesize projectsTableView = _projectsTableView;
@synthesize addButton = _addButton;
@synthesize editButton = _editButton;
@synthesize MOC = _MOC;
@synthesize FRC = _FRC;
@synthesize projectsArray = _projectsArray;
@synthesize versionLabel = _versionLabel;


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
	
	AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	self.MOC=[appDelegate managedObjectContext];
    
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	_versionLabel.text=[NSString stringWithFormat:@"V %@", versionString];
    
    isEditing=NO;
    
    [super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated{
	AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	[appDelegate saveContext];
	
	
	[super viewWillDisappear:animated];
}

-(void) viewWillAppear:(BOOL)animated{
	NSError *error;
	
	
	if (![self.FRC performFetch:&error]) {
		[NSException exceptionWithName:@"Error performing fetch" reason:@"error performing fetch" userInfo:nil];
	}
	
	[_projectsTableView reloadData];
	
	[super viewWillAppear:animated];
}

- (NSFetchedResultsController *)FRC {
	if(_FRC!=nil){
		return _FRC;
	}
	
	NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
	
	AppDelegate_Shared *appDelegate=(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *managedObjectContext=[appDelegate managedObjectContext];
	
	NSEntityDescription *entity=[NSEntityDescription entityForName:@"Project" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:20];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"projectName" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] 
									   initWithFetchRequest:fetchRequest 
									   managedObjectContext:managedObjectContext 
									   sectionNameKeyPath:@"projectName"
									   cacheName:nil];
	frc.delegate=self;
	[frc performFetch:nil];
//	NSLog(@"Fetched %i objects", [[frc fetchedObjects]count]);
	_FRC=frc;
	[fetchRequest release];
	return _FRC;
	
	
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark UITableView
-(IBAction)addProject:(id) sender{
	
    [AppDelegate_iPhone clickSoundEffect];
    
    [FlurryAPI logEvent:@"PROJECT_ADDED"];
    
	ProjectClass *newProject=
		(ProjectClass *)[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:self.FRC.managedObjectContext];
	newProject.projectName=@"";
	newProject.lastModified=[NSDate date];
	
	NSError *error = nil;
	if (![newProject.managedObjectContext save:&error]) {
		[NSException exceptionWithName:@"Save Error" reason:@"Error saving new project" userInfo:nil];
	}
	
	ProjectView *projectVC = [[ProjectView alloc] init];
	projectVC.selectedProject=newProject;
	[self.navigationController pushViewController:projectVC animated:YES];
	[projectVC release];
}

-(IBAction) editButtonTouch:(id) sender{
    [AppDelegate_iPhone clickSoundEffect];
    isEditing=!(isEditing);
    [self setEditing:isEditing animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
//	NSLog(@"Test");
	[_projectsTableView setEditing:editing animated:animated];
    [_projectsTableView reloadData];
	[super setEditing:editing animated:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Only one section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[self.FRC fetchedObjects] count]>0) {
        _editButton.hidden=NO;
    }else{
        _editButton.hidden=YES;
    }
    
	return [[self.FRC fetchedObjects] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	// A date formatter for the time stamp.
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
	
	static NSString *CellIdentifier = @"Cell";
	
    // Dequeue or create a new cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.textLabel.text=[[[self.FRC fetchedObjects] objectAtIndex:indexPath.row] valueForKey:@"projectName"];
//    NSLog(@"FontNames: %@", [UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
    cell.textLabel.minimumFontSize = 11.0;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25 ];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
//	cell.detailTextLabel.text=[dateFormatter stringFromDate:[[[self.FRC fetchedObjects] objectAtIndex:indexPath.row] valueForKey:@"lastModified"]];
    cell.backgroundColor=[UIColor clearColor];
    NSInteger sectionRows = [_projectsTableView numberOfRowsInSection:[indexPath section]];
    NSInteger row = [indexPath row];
    row=indexPath.row;
    UIImage *rowBackground;
    
    if (row == 0 && row == sectionRows - 1){
        rowBackground = [UIImage imageNamed:@"cellTopandBottom.png"];
    }
    else if (row == 0)
    {
        rowBackground = [UIImage imageNamed:@"cellTop.png"];
    }
    else if (row == sectionRows - 1)
    {
        rowBackground = [UIImage imageNamed:@"cellBottom.png"];
    }
    else
    {
        rowBackground = [UIImage imageNamed:@"cellMiddle.png"];
    }	

    cell.backgroundView = [[[UIImageView alloc] initWithImage:rowBackground] autorelease];

	return cell;
	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [FlurryAPI logEvent:@"PROJECT_DELETED"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	ProjectClass *selectedProject=[[self.FRC fetchedObjects] objectAtIndex:indexPath.row];
	
	ProjectView *projectVC = [[ProjectView alloc] init];

	projectVC.selectedProject=selectedProject;
	[self.navigationController pushViewController:projectVC animated:YES];
	[projectVC release];
	
}

#pragma mark -
#pragma mark dealloc and unload
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	//self.MOC=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.projectsTableView = nil;
    self.addButton = nil;
    self.editButton = nil;
    self.versionLabel = nil;

	[super viewDidUnload];
    
    
}


- (void)dealloc {
	
    self.projectsTableView = nil;
    self.addButton = nil;
    self.editButton = nil;
    self.MOC = nil;
    self.FRC = nil;
    self.projectsArray = nil;
	
    self.versionLabel = nil;
    [super dealloc];
}


@end
