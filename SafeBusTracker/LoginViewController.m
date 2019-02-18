//
//  LoginViewController.m
//  SafeBusTracker
//
//  Created by veena on 15/06/15.
//  Copyright (c) 2015 RainConcert. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
#define LOGIN @"Login"
@end
@implementation LoginViewController
NSString *parent_name;


- (void)viewDidLoad {
    [super viewDidLoad];
    //setting navigation bar title name and colour
    self.navigationItem.title = title_name;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //initData
   //setting navigationbar hidden
    self.navigationController.navigationBar.hidden =NO;
    //clear textfield values
    self.txtfld_mobile_number.text = @"";
    self.txtfld_password.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark- IBActions

//Authentication button action
- (IBAction)authenticateSelected:(UIButton *)sender{
    
    if(self.txtfld_mobile_number.text.length == 0 )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:SAFEBUSTRACKER_TITLE message:@"Fields cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if(_txtfld_password.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:SAFEBUSTRACKER_TITLE message:@"Fields cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    else{
        
        [self.txtfld_mobile_number resignFirstResponder];
        [self.txtfld_password resignFirstResponder];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self createAuthenticateRequest];
    }

    
   
}

#pragma mark- Connection Operation
//Server call
- (void)createAuthenticateRequest
{
    NSString *queryString  = [NSString stringWithFormat:@"%@?UserName=%@&Password=%@&Est_id=%@",LOGIN,self.txtfld_mobile_number.text, self.txtfld_password.text,establishment_id];
    
    connection = [[ConnectionOperation alloc]init];
    connection.delegate = self;
    [connection sendConnectionRequestForData:queryString forService:@""];
    connection.typeOfRequest = LOGIN;
        
}

- (void)connectionFailedWithError:(NSString *)description{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:SAFEBUSTRACKER_TITLE message:@"Your network connectivity seems to be weak. Please retry." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [HUD hide:YES];
}

- (void)reqCompletedWithData:(NSData *)responsData typeOfRequest:(NSString *)requestType{
    
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:responsData options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonDictionary == nil) {
        [self.view setUserInteractionEnabled:YES];
        return;
    }
    
    if([requestType isEqualToString:LOGIN]){
        if ([[jsonDictionary objectForKey:@"status"] isEqualToString:@"success"])
        {
            NSLog(@"authKey%@",[jsonDictionary objectForKey:@"authKey"]);
            parent_name    =[jsonDictionary objectForKey:@"parent_name"];
            NSLog(@"%@",parent_name);
            NSUserDefaults *saveKeyValues = [NSUserDefaults standardUserDefaults];
            [saveKeyValues setValue:[jsonDictionary objectForKey:@"authKey"]  forKey:@"authKey"];
            [saveKeyValues setValue:parent_name forKey:@"parent_name"];         
            
            [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"map view" object:self];
            self.txtfld_password.text = @"";         
            
        }
        
        else if ([[jsonDictionary objectForKey:@"status"] isEqualToString:@"failed"]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:SAFEBUSTRACKER_TITLE message:[jsonDictionary objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            self.txtfld_mobile_number.text = @"";
            self.txtfld_password.text = @"";
        }
    }

    [HUD hide:YES];
}
#pragma mark- textfield delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == self.txtfld_mobile_number)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [UIView animateWithDuration:0.4 animations:^{
            [self.view setFrame:CGRectMake(0.0, -50, 768.0, self.view.frame.size.height)];
        }];
        }
        else{
            [UIView animateWithDuration:0.4 animations:^{
                [self.view setFrame:CGRectMake(0.0, -50, 320.0, self.view.frame.size.height)];
            }];
        }
      
    }
    else if(textField == self.txtfld_password)
    {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [UIView animateWithDuration:0.4 animations:^{
                [self.view setFrame:CGRectMake(0.0, -90.0, 768.0, self.view.frame.size.height)];
            }];
        }
        else{
            [UIView animateWithDuration:0.4 animations:^{
                [self.view setFrame:CGRectMake(0.0, -90.0, 320.0, self.view.frame.size.height)];
            }];
        }
       
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.txtfld_mobile_number)
    {
        [textField resignFirstResponder];
        [self.txtfld_password becomeFirstResponder];
    }
    else if(textField == self.txtfld_password)
    {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [UIView animateWithDuration:0.4 animations:^{
                [self.view setFrame:CGRectMake(0.0, 0.0, 768.0, self.view.frame.size.height)];
            }];
            
        }
        else
        {
            [UIView animateWithDuration:0.4 animations:^{
                [self.view setFrame:CGRectMake(0.0, 0.0, 320.0, self.view.frame.size.height)];
            }];
            
        }
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //sign in textfields
    if (textField == self.txtfld_mobile_number)
    {
        [textField resignFirstResponder];
        [self.txtfld_password becomeFirstResponder];
    }
    else if(textField == self.txtfld_password)
    {
        [UIView animateWithDuration:0.4 animations:^{
            [self.view setFrame:CGRectMake(0.0, 0.0, 320.0, self.view.frame.size.height)];
        }];
        [textField resignFirstResponder];
    }
    
    return YES;
}
#pragma mark- touch
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtfld_mobile_number resignFirstResponder];
    [self.txtfld_password resignFirstResponder];
    
}


@end
