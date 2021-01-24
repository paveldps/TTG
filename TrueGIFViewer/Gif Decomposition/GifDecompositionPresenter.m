//
//  GifDecompositionPresenter.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#import "GifDecompositionPresenter.h"

@implementation GifDecompositionPresenter

- (void)setSearch:(NSString *)string {
    NSLog(@"UPDATE Text search");
    
    if (string.length < 2) {
        return;
    }
    
    [self queryGIFData: string];
}


// MARK: - Private
- (void)queryGIFData: (NSString*) string {
    
    NSString *queryUrlString = [NSString stringWithFormat:@"https://api.giphy.com/v1/gifs/search?api_key=kzb0iww1CJeIAeBp6ep9Ihsj3uTRO7TN&q=%@", string];
    
    NSURL *url = [NSURL URLWithString:queryUrlString];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    // Configure the session here.

    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    [self.view setIsLoadingProgress];
        
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200) {
            NSArray<NSURL*>* urls = [self urlFromData: data];
            
            NSLog(@"URLS: %@", url);
            
            [self.view setItems:urls];
        }
        
        [self.view setIsLoaded];
        // The response object contains the metadata (HTTP headers, status code)

        // The data object contains the response body

        // The error object contains any client-side errors (e.g. connection
        // failures) and, in some cases, may report server-side errors.
        // In general, however, you should detect server-side errors by
        // checking the HTTP status code in the response object.
    }] resume];
}

-(NSArray<NSURL*>*) urlFromData: (NSData*) rawData {
    NSError *parseError = nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:rawData
                                                                       options:0
                                                                         error:&parseError];
    
    NSArray *imagesRawData = responseDictionary[@"data"];
    NSMutableArray<NSURL*> *result = [NSMutableArray arrayWithCapacity:imagesRawData.count];
    
    [imagesRawData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *originalItemURL = obj[@"images"][@"original"][@"url"];
//        NSURL *originalItemURL = obj[@"images"][@"preview_gif"][@"url"];
        result[idx] = originalItemURL;
    }];
    
    return result;
}

@end
