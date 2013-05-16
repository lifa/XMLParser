#import <Foundation/Foundation.h>

@interface Test : NSObject
{
    NSError     *_XMLError;
    id          _responseXML;
}
- (id)responseXML;
@end
