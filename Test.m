
#import "Test.h"
#import "TBXML+ParseObject.h"

@implementation Test

- (NSData*)responseData
{
    NSString *str = @"<html><head><script type=\"text/javascript\" src=\"/example/xdom/lo.js\"></script></head><html>";
    
    NSData *data = [[NSData alloc] initWithBytes:[str UTF8String] length:[str length]];
    return [data autorelease];
}

- (id)responseXML
{
    NSDictionary *dic = nil;
    if ([self.responseData length] > 0)
    {
        TBXML *tbxml = [[TBXML alloc] initWithXMLData:self.responseData error:&_XMLError];

        if (!_XMLError)
        {
            dic = [tbxml parse];
        }
        else
        {
            NSLog(@"xml error %@",_XMLError);
        }

        [tbxml release];
    }
    return dic;
}


@end
