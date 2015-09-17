//
//  AppDelegate.m
//  SafeBusTracker
//
//  Created by veena on 15/06/15.
//  Copyright (c) 2015 RainConcert. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
LoginViewController *loginView;
MapViewController *mapView;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    //retrieve auth  key for nsuserdefaults
    NSUserDefaults *retrieveKey = [NSUserDefaults standardUserDefaults];
    NSString *authKey = [retrieveKey stringForKey:@"authKey"];
    
    //setting root view controller
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LoginNotification:)
                                                 name:@"login view"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mapNotification:)
                                                 name:@"map view"
                                               object:nil];
    
    //For auth key not equal to nil for calling map view page
    if(authKey !=nil){
         [[NSNotificationCenter defaultCenter] postNotificationName:@"map view" object:self];
    }
    else{
        
        // for calling login view page for login

        [[NSNotificationCenter defaultCenter] postNotificationName:@"login view" object:self];
    }
   
    [self.window makeKeyAndVisible];
    return YES;
}

//Login view
-(void)LoginNotification:(NSNotification *)aNotification
{
    loginView  = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    navController=[[UINavigationController alloc]initWithRootViewController:loginView];
    navController.interactivePopGestureRecognizer.enabled = NO;
    self.window.rootViewController=navController;
 
}
//Map view
-(void)mapNotification:(NSNotification *)aNotification
{
    
    //retrieve parent name in nsuserdefaults
    NSUserDefaults *retrieveKey = [NSUserDefaults standardUserDefaults];
    NSString *parentName =[retrieveKey stringForKey:@"parent_name"];
    mapView  = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    mapView.parentName = parentName;
    navController=[[UINavigationController alloc]initWithRootViewController:mapView];
    navController.interactivePopGestureRecognizer.enabled = NO;
    self.window.rootViewController=navController;
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
