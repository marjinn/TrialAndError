//
//  CQMNSObject.m
//  TrialAndError
//
//  Created by sanooj_s on 6/2/14.
//  Copyright (c) 2014 sanooj_s. All rights reserved.
//

#import "CQMNSObject.h"


#import <objc/runtime.h>

/**
 *  New delegateDeclaration
 * (Informal protocol )
 */

@interface CQMDelegateManager (CQMNSObjectDelegate)

@end


@implementation CQMNSObject

@end


static NSUInteger CountOfObect(id self,SEL _cmd,id obj);

static NSString* Description(id self,SEL _cmd);

void createClass (void)
{
    Class myClass = nil;
    myClass =
    objc_allocateClassPair([NSObject class], (const char *)"DemoClass", 0);
    
//    Method indexOfObject;
//    indexOfObject =
//    class_getInstanceMethod([NSArray class], @selector(indexOfObject:));
//    
//    const char* types = 0;
//    types = method_getTypeEncoding(indexOfObject);
//    
//    NSString* typesNS = nil;
//    typesNS = [NSString stringWithFormat:@"%s%s%s%s",
//               @encode(NSUInteger),
//               @encode(id),
//               @encode(SEL),
//               @encode(id)
//               ];
//    
//    const char* typesC = 0;
//    typesC = [typesNS UTF8String];
    
    Method description;
    description =
    class_getInstanceMethod([NSObject class], @selector(description));
 
    const char* typeEncodings = 0;
    typeEncodings = method_getTypeEncoding(description);
    
    class_addMethod(myClass, @selector(description), (IMP) Description, typeEncodings);
    
    class_addIvar(myClass, "foo", sizeof(id), rint(log2(sizeof(id))), @encode(id));
    
    objc_registerClassPair(myClass);
    
    id myInStance = [[myClass alloc]init];
    NSLog(@"myInStance %@",myInStance);
    
    [myInStance setValue:@"BUU" forKeyPath:@"foo"];
    
    
    
}


static NSString* Description(id self,SEL _cmd)
{
    NSString* tmpReturnStr = nil;
    tmpReturnStr = [NSString stringWithFormat:@"<%@ %p: foo=%@>", [self class], self, nil];
    
    return tmpReturnStr;
}



