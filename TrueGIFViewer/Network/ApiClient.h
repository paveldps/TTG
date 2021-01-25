//
//  ApiClient.h
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/25/21.
//

#ifndef ApiClient_h
#define ApiClient_h

#import <Foundation/Foundation.h>
#import "GifSearchItem.h"

@protocol ApiClient

- (void)searchWithString:(NSString *) string
                    page:(NSInteger) page
                     GIF:(void (^)(NSArray<GifSearchItem*> *, NSError *))result;

@end

#endif /* ApiClient_h */
