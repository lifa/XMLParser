
#import <Foundation/Foundation.h>
#import "TBXML.h"

extern NSString    *kxml_nodeValue_key;

@interface TBXML (ParseObject)

/**
 *  @brief return NSMutableDictionary if succeed, otherwise nil
 *
 *  @note   if value is empty, we won't add it to dictionary
 */
- (NSMutableDictionary*)parse;

@end
