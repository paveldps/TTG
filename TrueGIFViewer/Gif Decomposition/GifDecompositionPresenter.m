//
//  GifDecompositionPresenter.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#import "GifDecompositionPresenter.h"
#import "GifSearchItem.h"
#import "GiphyApiClient.h"

static double const kSearchThrottlingDelay = 0.2f;
static double const kSearchMinLength = 2;

@interface GifDecompositionPresenter()

@property (nonatomic, strong) id<ApiClient> apiClient;
@property (nonatomic, strong) NSString* searchString;
@property (nonatomic, strong) NSTimer* timer;

@end

@implementation GifDecompositionPresenter

-(instancetype)init {
    if (self = [super init]) {
        self.apiClient = [GiphyApiClient new];
    }
    return self;
}

- (void)setSearch:(NSString *)string {
    [self.timer invalidate];
    [self setSearchString: string];
    
    if (string.length < kSearchMinLength) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kSearchThrottlingDelay
                                                 repeats: FALSE
                                                   block:^(NSTimer * _Nonnull timer) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf queryGIFData: string];
    }];
}


// MARK: - Private
- (void)queryGIFData: (NSString*) string {
    [self.view setIsLoadingProgress];
    
    __weak typeof(self) weakSelf = self;
    [self.apiClient searchWithString:string GIF:^(NSArray<GifSearchItem *>* items, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.view setIsLoaded];
                if (0 < [items count]) {
                    [strongSelf.view showItems: items];
                } else {
                    [strongSelf.view showNoItemsWith: string];
                }
            });
        } else {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

@end
