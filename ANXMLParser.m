//
//  ANXMLParser.m
//  nuevo
//
//  Created by Brian Salazar on 8/23/13.
//  Copyright (c) 2013 Avenidanet. All rights reserved.
//

#import "ANXMLParser.h"

@implementation ANXMLParser

-(id)initWithURL:(NSString *)url
{
    self = [super init];
    if (self) {
        [self withURL:url];
    }
    return self;
}

/* CONNECTION */
-(void)withURL:(NSString *)url
{
    _url_xml = url;
}
-(void)execute
{
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url_xml]];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if([_delegate respondsToSelector:@selector(ANXMLParserComplete)]){
        [_delegate ANXMLParserComplete];
    }
    [NSThread detachNewThreadSelector:@selector(initParser) toTarget:self withObject:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if([_delegate respondsToSelector:@selector(ANXMLParserError)]){
        [_delegate ANXMLParserError];
    }
}

/* PARSE */
-(void)initParser
{
    nodes = [[NSMutableArray alloc]init];
    currentNode = [[NSMutableDictionary alloc]init];
    
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:responseData];
    [parser setDelegate:self];
    [parser parse];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser {
    if([_delegate respondsToSelector:@selector(ANXMLParserBegin)]){
        [_delegate ANXMLParserBegin];
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    [nodes removeLastObject];
    [_delegate ANXMLParserFinish:nodes];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    currentNameField = elementName;
    currentField = [NSMutableString string];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)str
{
    [currentField appendString:str];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:currentNameField]){
        [currentNode setObject:currentField forKey:currentNameField];
        currentField = nil;
    }else{
        [nodes addObject:[NSMutableDictionary dictionaryWithDictionary:currentNode]];
        currentNode = [[NSMutableDictionary alloc]init];
    }
}

@end
