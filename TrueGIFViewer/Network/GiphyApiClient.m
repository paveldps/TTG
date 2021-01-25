//
//  GiphyApiClient.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/25/21.
//

#import <Foundation/Foundation.h>
#import "GiphyApiClient.h"

static NSString * const kGyphyApiKey = @"kzb0iww1CJeIAeBp6ep9Ihsj3uTRO7TN";

@implementation GiphyApiClient

- (void)searchWithString: (NSString *_Nonnull) string
                     GIF: (void (^_Nonnull)(NSArray<GifSearchItem*>*_Nonnull, NSError *_Nullable)) result {
    
    NSURL *url = [self searchURL:string];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    __weak typeof(self) weakSelf = self;
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        
        if (error != nil) {
            result(@[], error);
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200) {
            [strongSelf decodeFromData:data GIF:result];
        } else {
            result(@[], nil);
        }
    
    }] resume];
}

-(NSURL*) searchURL: (NSString*) string {
    NSURLComponents *components = [NSURLComponents componentsWithString: @"https://api.giphy.com/v1/gifs/search"];
    [components setQueryItems: @[
         [NSURLQueryItem queryItemWithName:@"api_key" value: kGyphyApiKey],
         [NSURLQueryItem queryItemWithName:@"q" value: string]]
    ];
    
    return [components URL];
}

-(void) decodeFromData: (NSData*) rawData
                   GIF: (void (^_Nonnull)(NSArray<GifSearchItem*>*_Nonnull, NSError *_Nullable)) result {
    NSError *parseError = nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:rawData
                                                                       options:0
                                                                         error:&parseError];
    if (parseError != nil) {
        result(@[], parseError);
        return;
    }
    
    NSArray *imagesRawData = responseDictionary[@"data"];
    NSMutableArray *decoded = [NSMutableArray arrayWithCapacity:imagesRawData.count];
    
    [imagesRawData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        decoded[idx] = [[GifSearchItem alloc] initWithDictionary:obj[@"images"]];
    }];
    
    result(decoded, nil);
}

@end
