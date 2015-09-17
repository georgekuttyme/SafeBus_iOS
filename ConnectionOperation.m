//
//  ConnectionOperation.m
//  FitBenefit
//
//  Created by veena on 14/01/15.
//  Copyright (c) 2015 veena. All rights reserved.
//


#import "ConnectionOperation.h"

@interface ConnectionOperation(){
    
    NSMutableData *receivedData;
}
@end

@implementation ConnectionOperation

@synthesize delegate;
@synthesize urlConnection;
@synthesize typeOfRequest;

- (void)sendConnectionRequestForData:(NSString *)requestString forService:(NSString *) service{
    NSString *urlString;
    urlString = [NSString stringWithFormat:@"%@%@",ServerURL,requestString];
    NSURLRequest *mutableRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    if (mutableRequest != nil) {
        
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:mutableRequest delegate:self];
        self.urlConnection = connection;
    }
    if (urlConnection) {
        receivedData = [[NSMutableData alloc]init];
    }
    
}

- (void)stopUrlConnection{
    [urlConnection cancel];
    self.urlConnection = nil;
    delegate = nil;
    
}
#pragma mark -
#pragma mark Delegate Methods for NSURLConnection

/*
 This is a connection delegate that informs that the request failed to execute
 */


// The connection failed
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    if ((id)delegate && [(id)delegate respondsToSelector:@selector(connectionFailedWithError:)]) {
        
        NSString *errorLog = [error localizedDescription].length ? [error localizedDescription] : @"Unable to communicate with server. Please try again";
        [(id)delegate performSelector:@selector(connectionFailedWithError:) withObject:errorLog];
    }
}

// The connection received more data
/*
 The delegate is called whenever the any respondse is received from the server for the request send
 @param data-The data thats received fromt the server
 @param connection- the connection for which the data was received
 */


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}
// Initial response
/*
 this delegate method is called when the connection received any response from the server regarding the request thats send.
 This delegate is used to check the type of response like success failure etc
 */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger statusCode = [httpResponse statusCode];
    NSLog(@"response code %ld",(long)statusCode);
    if( statusCode == 200 ) {
        
    }
    else{
        NSString* statusError  = [NSString stringWithFormat:NSLocalizedString(@"HTTP Error: %ld", nil), statusCode];
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:statusError forKey:NSLocalizedDescriptionKey];
        NSError *error = [[NSError alloc] initWithDomain:@"DownloadUrlOperation"
                                                    code:statusCode
                                                userInfo:userInfo];
        
        NSLog(@"%@",error);
    }    
    
}


/*
 This function informs that the data has been fetched completely and is ready to finish the execution
 @param connection-The connection object for which the data has been fetched.
 */


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    if ((id)delegate && [(id)delegate respondsToSelector:@selector(reqCompletedWithData:typeOfRequest:)]) {
        
        [self.delegate reqCompletedWithData:receivedData typeOfRequest:typeOfRequest];
    }
    
    
}

@end
