//
//  GifDecompositionPresenter.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#import "GifDecompositionPresenter.h"
#import "GifSearchItem.h"

@interface GifDecompositionPresenter()

@property (nonatomic, strong) NSString* searchString;
@property (nonatomic, strong) NSTimer* timer;

@end

@implementation GifDecompositionPresenter

- (void)setSearch:(NSString *)string {
    [self.timer invalidate];
    
    if (string.length < 2) {
        return;
    }
    
    self.searchString = string;
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25 repeats: FALSE block:^(NSTimer * _Nonnull timer) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf queryGIFData: string];
    }];
}


// MARK: - Private
- (void)queryGIFData: (NSString*) string {
    NSString *queryUrlString = [NSString stringWithFormat:@"https://api.giphy.com/v1/gifs/search?api_key=kzb0iww1CJeIAeBp6ep9Ihsj3uTRO7TN&q=%@", string];
    
    NSURL *url = [NSURL URLWithString:queryUrlString];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    [self.view setIsLoadingProgress];
        
    __weak typeof(self) weakSelf = self;
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200) {
            [strongSelf.view setItems: [strongSelf gifRecordsFromData: data]];
        }
        
        [strongSelf.view setIsLoaded];
    }] resume];
}

-(NSArray<GifSearchItem*>*) gifRecordsFromData: (NSData*) rawData {
    NSError *parseError = nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:rawData
                                                                       options:0
                                                                         error:&parseError];
    
    NSArray *imagesRawData = responseDictionary[@"data"];
    NSMutableArray<GifSearchItem*> *result = [NSMutableArray arrayWithCapacity:imagesRawData.count];
    
    [imagesRawData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        result[idx] = [[GifSearchItem alloc] initWithDictionary:obj[@"images"]];
    }];
    
    return result;
}

@end
