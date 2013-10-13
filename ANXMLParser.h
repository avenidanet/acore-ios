//
//  ANXMLParser.h
//  nuevo
//
//  Created by Brian Salazar on 8/23/13.
//  Copyright (c) 2013 Avenidanet. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ANXMLParserDelegate <NSObject>
@required
-(void)ANXMLParserFinish:(NSMutableArray *)data;
@optional
-(void)ANXMLParserComplete;
-(void)ANXMLParserError;
-(void)ANXMLParserBegin;
@end

@interface ANXMLParser : NSObject <NSURLConnectionDelegate,NSXMLParserDelegate>
{
    NSMutableData *responseData;
    NSURLRequest *request;
    NSURLConnection *conn;
    
    NSMutableString *currentField;
    NSString *currentNameField;
    
    NSMutableDictionary *currentNode;
    NSMutableArray *nodes;
    
    
}

@property (strong, nonatomic) id <ANXMLParserDelegate> delegate;
@property (strong, nonatomic) NSString *url_xml; 

-(id)initWithURL:(NSString *)url;
-(void)withURL:(NSString *)url;
-(void)execute;
@end

