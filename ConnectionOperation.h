//
//  ConnectionOperation.h
//  FitBenefit
//
//  Created by veena on 14/01/15.
//  Copyright (c) 2015 veena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constants.h"
@protocol HTTPConnectionDelegate <NSObject>
@optional
-(void)connectionFailedWithError:(NSString*)description;
-(void)reqCompletedWithData:(NSData*)responsData typeOfRequest:(NSString *)requestType;
@end
@interface ConnectionOperation : NSObject
@property(strong,retain) NSURLConnection *urlConnection;
@property(strong,retain) NSString *typeOfRequest;
@property(assign) id <HTTPConnectionDelegate> delegate;
- (void)stopUrlConnection;
- (void)sendConnectionRequestForData: (NSString *) requestString
                          forService: (NSString *) service ;

@end
