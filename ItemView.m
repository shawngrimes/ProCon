//
//  ItemView.m
//  ProCon
//
//  Created by shawn on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemView.h"


@implementation ItemView

@synthesize argumentTitleTF, proConSegment, scorePicker, saveButton;
@synthesize selectedArgument;
@synthesize scoreV8Picker=_scoreV8Picker;
@synthesize scoreHeadingImageView = _scoreHeadingImageView;
@synthesize thumbImageView = _thumbImageView;

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
	
	self.title=@"Argument Details";
	
	self.argumentTitleTF.text=self.selectedArgument.argDescription;
    
    self.scoreV8Picker=[[[V8HorizontalPickerView alloc] initWithFrame:CGRectMake(18, 300, 280, 44)] autorelease];
    _scoreV8Picker.backgroundColor=[UIColor clearColor];
    _scoreV8Picker.selectedTextColor=[UIColor whiteColor];
    _scoreV8Picker.textColor   = [UIColor blackColor];
    _scoreV8Picker.delegate    = self;
	_scoreV8Picker.dataSource  = self;
	_scoreV8Picker.elementFont = [UIFont boldSystemFontOfSize:24.0f];
	_scoreV8Picker.selectionPoint = CGPointMake(140, 0);
    
	[self.view addSubview:_scoreV8Picker];
    
    if([self.selectedArgument.score integerValue]<0){
        self.proConSegment.selectedSegmentIndex=1;
        _scoreHeadingImageView.image=[UIImage imageNamed:@"conArgumentsHeading.png"];
        CGAffineTransform transform = 
        CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
        _thumbImageView.transform = transform;
	}else{
        _scoreHeadingImageView.image=[UIImage imageNamed:@"proArgumentsHeading.png"];
        CGAffineTransform transform = 
        CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90));
        _thumbImageView.transform = transform;
    }
   
    [_scoreV8Picker scrollToElement:0 animated:YES];
    
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction) saveArgument:(id)sender{
    [AppDelegate_iPhone clickSoundEffect];
	self.selectedArgument.argDescription=self.argumentTitleTF.text;
	self.selectedArgument.score=[NSNumber numberWithInt:([_scoreV8Picker currentSelectedIndex]+1)];
	switch (self.proConSegment.selectedSegmentIndex) {
		case 0:
			self.selectedArgument.score=[NSNumber numberWithInt:abs([self.selectedArgument.score integerValue])];
			break;
		case 1:
			self.selectedArgument.score=[NSNumber numberWithInt:-1*abs([self.selectedArgument.score integerValue])];
		default:
			[NSException exceptionWithName:@"Data Picker Error" reason:@"Error with selectedSegmentIndex" userInfo:nil];
			break;
	}
	
	if([selectedArgument isUpdated]){
//		NSLog(@"Saving MOC");
		NSError *error = nil;
		if (![selectedArgument.managedObjectContext save:&error]) {
			[NSException exceptionWithName:@"Save Error" reason:@"Error saving argument" userInfo:nil];
		}
	}
	
	[self.navigationController popViewControllerAnimated:YES];
	
}

-(IBAction) goBack:(id)sender{
    [AppDelegate_iPhone clickSoundEffect];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
	
}
#pragma mark -
#pragma mark HorizontalPickerView DataSource Methods
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
	return 10;
}

#pragma mark -
#pragma mark HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
	switch (proConSegment.selectedSegmentIndex) {
		case 0:
			return [NSString stringWithFormat:@"+%i", index+1];
			break;
		case 1:
			return [NSString stringWithFormat:@"-%i", index+1];
		default:
			[NSException exceptionWithName:@"Data Picker Error" reason:@"Error with selectedSegmentIndex" userInfo:nil];
			break;
	}
    return @"0";
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
	CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
	NSString *text;
    switch (proConSegment.selectedSegmentIndex) {
		case 0:
			text= [NSString stringWithFormat:@"+%i", index+1];
			break;
		case 1:
			text= [NSString stringWithFormat:@"-%i", index+1];
		default:
			[NSException exceptionWithName:@"Data Picker Error" reason:@"Error with selectedSegmentIndex" userInfo:nil];
			break;
	}
	CGSize textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]
					   constrainedToSize:constrainedSize
						   lineBreakMode:UILineBreakModeWordWrap];
	return textSize.width + 40.0f; // 20px padding on each side
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
//	self.infoLabel.text = [NSString stringWithFormat:@"Selected index %d", index];
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
	switch (proConSegment.selectedSegmentIndex) {
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

/*
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    if(view==nil){
        view=[[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 44)] autorelease];
    }
    view.backgroundColor=[UIColor clearColor];
    NSLog(@"Subviews: %i", [view.subviews count]);
//    UILabel *scoreLabel=[[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 44)] autorelease];
    switch (proConSegment.selectedSegmentIndex) {
		case 0:
//            (UILabel *)view.text=[NSString stringWithFormat:@"+%i", row+1];
			break;
		case 1:
//			return [NSString stringWithFormat:@"-%i", row+1];
//            view.text=[NSString stringWithFormat:@"-%i", row+1];
            
		default:
			[NSException exceptionWithName:@"Data Picker Error" reason:@"Error with selectedSegmentIndex" userInfo:nil];
			break;
	}
//    [view addSubview:scoreLabel];
    NSLog(@"Subviews2: %i", [view.subviews count]);
    return view;
}
*/
#pragma mark -
#pragma mark dealloc
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.argumentTitleTF=nil;
	self.proConSegment=nil;
	self.scorePicker=nil;
	self.saveButton=nil;
	self.scoreV8Picker=nil;
	self.selectedArgument=nil;
    self.scoreHeadingImageView = nil;
    self.thumbImageView = nil;

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    self.scoreHeadingImageView = nil;
    self.thumbImageView = nil;
	[argumentTitleTF release];
	[proConSegment release];
	[scorePicker release];
	[saveButton release];
    [_scoreV8Picker release];
	[selectedArgument release];
	
    [super dealloc];
}


@end
