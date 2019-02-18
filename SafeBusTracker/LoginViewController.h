//
//  LoginViewController.h
//  SafeBusTracker
//
//  Created by veena on 15/06/15.
//  Copyright (c) 2015 RainConcert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"
#import "MapViewController.h"
#import "FetchMapDetailModel.h"
//server hit
#import "ConnectionOperation.h"
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController<HTTPConnectionDelegate,UITextFieldDelegate,MBProgressHUDDelegate>{
    //declare connection class object
    ConnectionOperation *connection;
    MBProgressHUD *HUD;//declare activityindicator class object
    
}
//Declare textfields for  mobile number and password
@property (strong, nonatomic) IBOutlet UITextField *txtfld_mobile_number;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_password;

- (IBAction)authenticateSelected:(UIButton *)sender;
@end
