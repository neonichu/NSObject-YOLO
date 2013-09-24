#import <Foundation/Foundation.h>

#import "NSObject+YOLO.h"

int main(int argc, char *argv[]) {
  @autoreleasepool {
  	[@"" yl_swizzleSelector:@selector(stringByAppendingString:) withBlock:^NSString*(id sself, NSString* arg){
  		NSString* originalValue;
  		[sself yl_performSelector:@selector(stringByAppendingString:) 
  					returnAddress:&originalValue 
  				argumentAddresses:&arg, NULL];
  		return [originalValue stringByAppendingString:@" YOLO!"];
  	}];

    NSLog(@"%@", [@"foo" stringByAppendingString:@"bar"]);
  }
}
