
#import "TBXML+ParseObject.h"

NSString    *kxml_nodeValue_key     =   @"xml_node_key";

@implementation TBXML (ParseObject)

- (NSMutableDictionary*)parse
{
    NSMutableDictionary *dic = nil;
    
    if (self.rootXMLElement && !self.rootXMLElement->firstChild)
    {
        dic = [NSMutableDictionary dictionaryWithObject:[TBXML textForElement:self.rootXMLElement] forKey:[TBXML elementName:self.rootXMLElement]];
    }
    else
    {
        dic = [NSMutableDictionary dictionaryWithCapacity:1];
        [self traverseChildrenBeginFrom:self.rootXMLElement of:dic];
    }
    
    return dic;
}

- (void)traverseChildrenBeginFrom:(TBXMLElement*)element of:(NSMutableDictionary*)parent
{
    do {
        @autoreleasepool {
            
            NSMutableDictionary *result = [NSMutableDictionary dictionary];
            
            // current element
            NSString *val = [TBXML textForElement:element];
            NSString *keyName = [TBXML elementName:element];
            
            // attributes
            __block NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            [TBXML iterateAttributesOfElement:element withBlock:^(TBXMLAttribute *at,NSString *name, NSString *val) {
                [attributes setObject:val forKey:name];
            }];
            [result addEntriesFromDictionary:attributes];

            // children
            if (element->firstChild)
            {
                [self traverseChildrenBeginFrom:element->firstChild of:result];
            }
            
            // add current element(and its children) to parent
            // Notes: if has no such item, add it as dictionay. else composite it with other values together as array
            id oldObject = [parent objectForKey:keyName];
            if (oldObject == nil) { // case 1: add new item
                if ([result count] == 0 && [val length] > 0) {
                    [parent setObject:val forKey:keyName];
                }
                else {
                    if ([val length] > 0) {
                        if ([attributes count] == 0) {
                            [result setObject:val forKey:keyName];
                        }
                        else {
                            [result setObject:val forKey:kxml_nodeValue_key];
                        }
                    }
                    if ([result count] > 0) {
                        [parent setObject:result forKey:keyName];
                    }
                }
            }
            else if ([oldObject isKindOfClass:[NSDictionary class]]) {  // case 2: has & one item
                NSMutableArray *all = [NSMutableArray arrayWithObjects:oldObject,result, nil];
                [parent setObject:all forKey:keyName];
            }
            else if ([oldObject isKindOfClass:[NSArray class]]) {   // case 3: already array
                [oldObject addObject:result];
            }
        
        }
    }
    while ((element = element->nextSibling));
    
}

@end
