//
//  GiphyApiClient.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/25/21.
//

#import <Foundation/Foundation.h>
#import "GiphyApiClient.h"

static NSString * const kGyphyApiKey = @"kzb0iww1CJeIAeBp6ep9Ihsj3uTRO7TN";
static NSInteger const kPageSize = 50;

@implementation GiphyApiClient

#pragma mark - ApiClient
- (void)searchWithString:(NSString *)string
                    page:(NSInteger)page
                     GIF:(void (^)(NSArray<GifSearchItem*>*, NSError *)) result {
    NSURL *url = [self searchURL:string page:page];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    __weak typeof(self) weakSelf = self;
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (error != nil) {
            return result(@[], error);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200) {
            [strongSelf decodeFromData:data GIF:result];
        } else {
            result(@[], nil);
        }
    
    }] resume];
}

#pragma mark - Private

-(NSURL*)searchURL:(NSString*)string
              page:(NSInteger)page {
    NSURLComponents *components = [NSURLComponents componentsWithString: @"https://api.giphy.com/v1/gifs/search"];
    [components setQueryItems:@[
         [NSURLQueryItem queryItemWithName:@"api_key" value:kGyphyApiKey],
         [NSURLQueryItem queryItemWithName:@"q" value:string],
         [NSURLQueryItem queryItemWithName:@"limit" value:@(kPageSize).stringValue],
         [NSURLQueryItem queryItemWithName:@"offset" value:@(kPageSize * page).stringValue]]
     
    ];
    
    return [components URL];
}

-(void)decodeFromData:(NSData*)rawData
                  GIF:(void (^)(NSArray<GifSearchItem*>*, NSError *))result {
    NSError *parseError = nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:rawData
                                                                       options:0
                                                                         error:&parseError];
    if (parseError != nil) {
        return result(@[], parseError);
    }
    
    NSArray *imagesRawData = responseDictionary[@"data"];
    if (!imagesRawData) {
        return result(@[], nil);
    }
    
    NSMutableArray *decoded = [NSMutableArray arrayWithCapacity:imagesRawData.count];
    [imagesRawData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        decoded[idx] = [[GifSearchItem alloc] initWithOriginalUrl:obj[@"images"][@"original"][@"url"]];
    }];
    
    result(decoded, nil);
}

@end
