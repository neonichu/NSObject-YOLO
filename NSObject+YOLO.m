#import <objc/runtime.h>

#import "NSObject+YOLO.h"

SEL yl_aliasForSelector(SEL originalSelector) {
	return NSSelectorFromString([NSString stringWithFormat:@"yl_%s", 
		[NSStringFromSelector(originalSelector) cStringUsingEncoding:NSUTF8StringEncoding]]);
}

static BOOL Swizzle(Class c, SEL orig, SEL new) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    
    if (class_addMethod(c, orig,
                        method_getImplementation(newMethod),
                        method_getTypeEncoding(newMethod))) {
        IMP imp = class_replaceMethod(c, new,
        				method_getImplementation(origMethod),
                        method_getTypeEncoding(origMethod));
    	return imp != NULL;
    }
    
    method_exchangeImplementations(origMethod, newMethod);
    return YES;
}

@implementation NSObject (YOLO)

-(void)yl_logErrorForSelector:(SEL)originalSelector {
	NSLog(@"Could not swizzle %@ on %@.", NSStringFromSelector(originalSelector), NSStringFromClass(self.class));
}

// From: https://gist.github.com/bsneed/507344
- (void)yl_performSelector:(SEL)aSelector returnAddress:(void *)result argumentAddresses:(void *)arg1, ...
{
	aSelector = yl_aliasForSelector(aSelector);

	va_list args;
	va_start(args, arg1);
	
	if([self respondsToSelector:aSelector])
	{
		NSMethodSignature *methodSig = [[self class] instanceMethodSignatureForSelector:aSelector];
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: methodSig];
		[invocation setTarget:self];
		[invocation setSelector:aSelector];
		if (arg1)
			[invocation setArgument:arg1 atIndex:2];
		void *theArg = nil;
		for (int i = 3; i < [methodSig numberOfArguments]; i++)
		{
			theArg = va_arg(args, void *);
			if (theArg)
				[invocation setArgument:theArg atIndex:i];
		}
		[invocation invoke];	
		if (result)
			[invocation getReturnValue:result];
	}
	
	va_end(args);
}

-(void)yl_swizzleSelector:(SEL)originalSelector withBlock:(id)block {
	Method m = class_getInstanceMethod(self.class, originalSelector);
	IMP imp = imp_implementationWithBlock(block);

	SEL newSelector = yl_aliasForSelector(originalSelector);

	if (!class_addMethod(self.class, newSelector, imp, method_getTypeEncoding(m))) {
		[self yl_logErrorForSelector:originalSelector];
		return;
	}

	if (!Swizzle(self.class, originalSelector, newSelector)) {
		[self yl_logErrorForSelector:originalSelector];
	}
}

@end
