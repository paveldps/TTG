//
//  GiphyApiClient.h
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/25/21.
//

#ifndef GifApiClient_h
#define GifApiClient_h

#import <Foundation/Foundation.h>
#import "GifSearchItem.h"

@protocol ApiClient
- (void)searchWithString: (NSString *_Nonnull) string
                     GIF:(void (^_Nonnull)(NSArray<GifSearchItem*> *_Nonnull, NSError *_Nullable)) result;
@end

@interface GiphyApiClient : NSObject <ApiClient>

@end


#endif /* GifApiClient_h */
