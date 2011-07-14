//
//  ItemView.h
//  ProCon
//
//  Created by shawn on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "V8HorizontalPickerView.h"
#import "ProjectClass.h"
#import "ArgumentClass.h"
#import "AppDelegate_iPhone.h"

@interface ItemView : UIViewController <UITextFieldDelegate, V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource,UIPickerViewDataSource, UIPickerViewDelegate> {
	UITextField *argumentTitleTF;
	UISegmentedControl *proConSegment;
	UIPickerView *scorePicker;
	UIButton *saveButton;

    V8HorizontalPickerView *_scoreV8Picker;
    UIImageView *_scoreHeadingImageView;
    UIImageView *_thumbImageView;
	ArgumentClass *selectedArgument;
	
}

@property (nonatomic, retain) IBOutlet UIImageView *scoreHeadingImageView;
@property (nonatomic, retain) IBOutlet UIImageView *thumbImageView;


@property (nonatomic, retain)     V8HorizontalPickerView *scoreV8Picker;
@property (nonatomic, retain) IBOutlet 	UITextField *argumentTitleTF;
@property (nonatomic, retain) IBOutlet UISegmentedControl *proConSegment;
@property (nonatomic, retain) IBOutlet UIPickerView *scorePicker;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;

@property (nonatomic, retain) ArgumentClass *selectedArgument;

-(IBAction) saveArgument:(id)sender;
-(IBAction) goBack:(id)sender;

@end
