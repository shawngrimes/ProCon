//
//  SummaryView.h
//  ProCon
//
//  Created by shawn on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "ArgumentClass.h"
#import "ProjectClass.h"
#import "ItemView.h"

@class AppDelegate_iPhone;

@interface SummaryView : UIViewController <UITableViewDelegate>  {

	ProjectClass *selectedProject;
	NSMutableArray *proArguments;
	NSMutableArray *conArguments;
	
    UIImageView *thumbImageView;
	UIImageView *_scoreBannerImageView;
    UILabel *_argumentTitleLabel;
	UILabel *_scoreLabel;
    UIScrollView *_decisionScrollView;
    NSManagedObjectContext *_MOC;
    UILabel *_scoreLabelSaying;
    
	UITableView *_argumentsTableView;
    
    BOOL isEditing;
	
}

@property (nonatomic,retain) NSManagedObjectContext *MOC;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabelSaying;
@property (nonatomic, retain) IBOutlet UIScrollView *decisionScrollView;

@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;

@property (nonatomic, retain) IBOutlet UILabel *argumentTitleLabel;

@property (nonatomic, retain) IBOutlet UIImageView *scoreBannerImageView;

@property (nonatomic, retain) IBOutlet UIImageView *thumbImageView;

@property (nonatomic, retain) 	ProjectClass *selectedProject;

@property (nonatomic, retain) IBOutlet 	UITableView *argumentsTableView;
@property (nonatomic, retain) NSMutableArray *proArguments;
@property (nonatomic, retain) NSMutableArray *conArguments;


- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration 
              curve:(int)curve degrees:(CGFloat)degrees;

-(IBAction) goBack:(id)sender;
-(IBAction) toggleEdit:(id)sender;

@end
