// ==============================================================================================
//  TBXML+ParseObject.m
//  Easy use of TBXML
//
// ==============================================================================================
//  Copyright (c) 2013 lifa.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
// ==============================================================================================

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
