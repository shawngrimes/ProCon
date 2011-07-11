//
//  SummaryView.m
//  ProCon
//
//  Created by shawn on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "SummaryView.h"



@implementation SummaryView

@synthesize selectedProject;
@synthesize argumentsTableView=_argumentsTableView;
@synthesize proArguments;
@synthesize conArguments;
@synthesize thumbImageView;
@synthesize scoreBannerImageView = _scoreBannerImageView;
@synthesize argumentTitleLabel = _argumentTitleLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize decisionScrollView = _decisionScrollView;
@synthesize MOC=_MOC;
@synthesize scoreLabelSaying=_scoreLabelSaying;

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
	
	
    _argumentTitleLabel.text=self.selectedProject.projectName;
    
//	self.navigationItem.rightBarButtonItem=self.editButtonItem;
	
	self.proArguments=[NSMutableArray arrayWithCapacity:1];
	self.conArguments=[NSMutableArray arrayWithCapacity:1];
	
    int totalScore=0;
    
	for(ArgumentClass *argument in selectedProject.arguments){
		totalScore+=[argument.score integerValue];
        if([argument.score integerValue]>0){
			[proArguments addObject:argument];
		}else{
			[conArguments addObject:argument];
		}
	}
    self.MOC=self.selectedProject.managedObjectContext;
	
    
    if(totalScore>0){
        _scoreBannerImageView.image=[UIImage imageNamed:@"argumentScorePro.png"];
        _scoreLabel.text=[NSString stringWithFormat:@"Score: +%i", totalScore];
    }else if(totalScore<0){
        _scoreBannerImageView.image=[UIImage imageNamed:@"argumentScoreCon.png"];
        _scoreLabel.text=[NSString stringWithFormat:@"Score: %i", totalScore];
    }else{
        _scoreBannerImageView.image=[UIImage imageNamed:@"argumentScoreNeutral.png"];
        _scoreLabel.text=[NSString stringWithFormat:@"Score: %i", totalScore];
        _scoreLabelSaying.text=@"Need More Input";
    
    }

	
    _decisionScrollView.showsVerticalScrollIndicator=YES;
    _decisionScrollView.contentSize=CGSizeMake(290, 960);
    
    isEditing=NO;
    

    
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    float meanScore=0.0;
    float decisionScore=[[self.selectedProject getDecisionScore] floatValue];
    float argumentCount=(float) [self.selectedProject.arguments count];
    float argumentAbsTotal=[[self.selectedProject getDecisionAbsScore] floatValue];
    meanScore=decisionScore/argumentAbsTotal;
    float percentageScore= meanScore;
//    NSLog(@"Rotate by: %f", percentageScore*100);
    if(percentageScore>0.0 || percentageScore<0.0){
        [self rotateImage:self.thumbImageView duration:1.0 curve:UIViewAnimationCurveEaseIn degrees:(percentageScore*100)];
    }
}

- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration 
              curve:(int)curve degrees:(CGFloat)degrees
{
    if(degrees>0.0 && degrees<45.0){
        _scoreLabelSaying.text=@"Most Likely";
    }else if(degrees>=45.0){
        _scoreLabelSaying.text=@"Heck Yeah!";
    }else if(degrees<0.0 && degrees > -45.0){
        _scoreLabelSaying.text=@"Maybe Not";
    }else if(degrees<=-45.0){
        _scoreLabelSaying.text=@"Oh Lordy No!";
    }
    
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve
                     animations:^{
//                         NSLog(@"Rotating Thumb %f degrees", degrees);
                         //self.argumentConfirmationView.text=@"Argument Added";
                         CGAffineTransform transform = 
                         CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
                         image.transform = transform;

                         
                     }
                     completion:^(BOOL finished){
//                         NSLog(@"Done rotating thumb");
                     }];

    
/*    
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = 
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
 */
}


#pragma mark -
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImage *headerImage;
    switch (section) {
		case 0:
            headerImage=[UIImage imageNamed:@"proArgumentsHeading.png"];
            break;
        case 1:
            headerImage=[UIImage imageNamed:@"conArgumentsHeading.png"];
			break;
		default:
			[NSException exceptionWithName:@"Load View Error" reason:@"Unknown section" userInfo:nil];
			break;
	}

    return [[[UIImageView alloc] initWithImage:headerImage] autorelease];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	switch (section) {
        case 0:
			return [proArguments count];
			break;
		case 1:
			return [conArguments count];
			break;

		default:
			[NSException exceptionWithName:@"Load View Error" reason:@"Unknown section" userInfo:nil];
			break;
	}
	return 0;
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text=[[proArguments objectAtIndex:indexPath.row] valueForKey:@"argDescription"];
			cell.detailTextLabel.text=[[[proArguments objectAtIndex:indexPath.row] valueForKey:@"score"] stringValue];
            cell.backgroundColor=[UIColor clearColor];
            NSInteger sectionRows = [_argumentsTableView numberOfRowsInSection:[indexPath section]];
            NSInteger row = [indexPath row];
            UIImage *rowBackground;
            
            if (row == 0 && row == sectionRows - 1){
                rowBackground = [UIImage imageNamed:@"cellTopandBottomPro.png"];
            }
            else if (row == 0)
            {
                rowBackground = [UIImage imageNamed:@"cellTopPro.png"];
            }
            else if (row == sectionRows - 1)
            {
                rowBackground = [UIImage imageNamed:@"cellBottomPro.png"];
            }
            else
            {
                rowBackground = [UIImage imageNamed:@"cellMiddlePro.png"];
            }	
            
            cell.backgroundView = [[[UIImageView alloc] initWithImage:rowBackground] autorelease];

			break;
		case 1:
			cell.textLabel.text=[[conArguments objectAtIndex:indexPath.row] valueForKey:@"argDescription"];
			cell.detailTextLabel.text=[[[conArguments objectAtIndex:indexPath.row] valueForKey:@"score"] stringValue];
            cell.backgroundColor=[UIColor clearColor];
            NSInteger conSectionRows = [_argumentsTableView numberOfRowsInSection:[indexPath section]];
            NSInteger conRow = [indexPath row];
            UIImage *conRowBackground;
            
            if (conRow == 0 && conRow == conSectionRows - 1){
                rowBackground = [UIImage imageNamed:@"cellTopandBottomCon.png"];
            }
            else if (conRow == 0)
            {
                rowBackground = [UIImage imageNamed:@"cellTopCon.png"];
            }
            else if (conRow == conSectionRows - 1)
            {
                rowBackground = [UIImage imageNamed:@"cellBottomCon.png"];
            }
            else
            {
                rowBackground = [UIImage imageNamed:@"cellMiddleCon.png"];
            }	
            
            cell.backgroundView = [[[UIImageView alloc] initWithImage:rowBackground] autorelease];

			break;
		default:
			[NSException exceptionWithName:@"Load Cell Error" reason:@"Unknown section" userInfo:nil];
			break;
	}
	
	return cell;
	
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		ArgumentClass *argumentToDelete;
		switch (indexPath.section) {
			case 0:
				argumentToDelete=[proArguments objectAtIndex:indexPath.row];
				[proArguments removeObjectAtIndex:indexPath.row];
				break;
			case 1:
				argumentToDelete=[conArguments objectAtIndex:indexPath.row];
				[conArguments removeObjectAtIndex:indexPath.row];
				break;
			default:
				[NSException exceptionWithName:@"Commit Edit Error" reason:@"Unknown section" userInfo:nil];
				break;
		}
		
        
//        NSLog(@"MOC: %@", argumentToDelete.managedObjectContext );
        NSError *error = nil;
        if(![argumentToDelete validateForDelete:&error]){
            [NSException exceptionWithName:@"Delete Error" reason:@"Error deleting project" userInfo:nil];
        }
              
        NSManagedObjectContext *argMOC=[argumentToDelete managedObjectContext];
        [argMOC deleteObject:argumentToDelete];
		
        
        // Commit the change.
        error = nil;
		if([argMOC hasChanges]){
			
//			NSLog(@"Saving after delete");
			if (![argumentToDelete.managedObjectContext save:&error]) {
				[NSException exceptionWithName:@"Save Error" reason:@"Error deleting project" userInfo:nil];
			}
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		}
//        [argMOC release];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	ArgumentClass *argumentSelected;
	switch (indexPath.section) {
		case 0:
			argumentSelected=[proArguments objectAtIndex:indexPath.row];
			break;
		case 1:
			argumentSelected=[conArguments objectAtIndex:indexPath.row];
			break;
		default:
			[NSException exceptionWithName:@"Commit Edit Error" reason:@"Unknown section" userInfo:nil];
			break;
	}
	
	ItemView *argumentVC = [[ItemView alloc] init];
	
	argumentVC.selectedArgument=argumentSelected;
	[self.navigationController pushViewController:argumentVC animated:YES];
	[argumentVC release];
	
}

-(IBAction) goBack:(id)sender{
    [AppDelegate_iPhone clickSoundEffect];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction) toggleEdit:(id)sender{
    [AppDelegate_iPhone clickSoundEffect];
    isEditing=!(isEditing);
    [self setEditing:isEditing animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	//	NSLog(@"Test");
	[_argumentsTableView setEditing:editing animated:animated];
	[super setEditing:editing animated:animated];
}

#pragma mark -
#pragma mark dealloc
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    self.scoreBannerImageView = nil;
    self.scoreLabel = nil;
    self.decisionScrollView = nil;
    self.MOC=nil;
	self.proArguments=nil;
	self.conArguments=nil;
    self.thumbImageView = nil;
    
    self.argumentsTableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    self.scoreBannerImageView = nil;
    self.MOC=nil;    
    self.decisionScrollView = nil;
    self.argumentsTableView = nil;
    self.scoreLabel = nil;
    [thumbImageView release];
	[proArguments release];
	[conArguments release];
    [super dealloc];
}


@end
