//
//  AppDelegate_iPad.h
//  ProCon
//
//  Created by shawn on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"
#import "MasterTableViewController.h"
//#import "MGSplitViewController.h"

//@class MasterTableViewController;

@interface AppDelegate_iPad : AppDelegate_Shared {

    UINavigationController *navController;
    MasterTableViewController *masterViewController;
    IBOutlet MGSplitViewController *mgSplitVC;

}
@property (nonatomic, retain) IBOutlet MasterTableViewController *masterViewController;

@property (nonatomic, retain) IBOutlet UINavigationController *navController;


@end

