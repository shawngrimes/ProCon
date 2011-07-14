//
//  AppDelegate_iPhone.m
//  ProCon
//
//  Created by shawn on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "ProjectListView.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AppDelegate_iPhone


static SystemSoundID soundFileObjectClick;

+ (void) clickSoundEffect
{
    AudioServicesPlaySystemSound (soundFileObjectClick);
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    [FlurryAPI startSession:@"W996ZMATUJZ3JPDANYLL"];
    
    
    CFURLRef soundFileURLRefClick  = CFBundleCopyResourceURL (CFBundleGetMainBundle (), CFSTR ("mouseClick"), CFSTR ("caf"), NULL);
    AudioServicesCreateSystemSoundID (soundFileURLRefClick, &soundFileObjectClick);
    
	
	ProjectListView *mainVC=[[ProjectListView alloc] initWithNibName:nil bundle:nil];
	mainVC.MOC=[self managedObjectContext];
	UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:mainVC];
    navigationController.navigationBarHidden=YES;

    [FlurryAPI logAllPageViews:navigationController];
    
	[window	 addSubview:navigationController.view];
	
	
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.

     Superclass implementation saves changes in the application's managed object context before the application terminates.
     */
	[super applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 Superclass implementation saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	[super applicationWillTerminate:application];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    [super applicationDidReceiveMemoryWarning:application];
}




@end

