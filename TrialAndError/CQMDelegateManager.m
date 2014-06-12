//
//  CQMDelegateManager.m
//  TrialAndError
//
//  Created by sanooj_s on 6/2/14.
//  Copyright (c) 2014 sanooj_s. All rights reserved.
//

#import "CQMDelegateManager.h"

@implementation CQMDelegateManager

-(id)init
{
    self->_proxiedObject = nil;
    self->_justResponded = NO;
    self->_logOnNoResponse = NO;
    
    return self;
}

-(NSMethodSignature*)methodSignatureForSelector:(SEL)sel
{
    NSMethodSignature* sign = nil;
    
    sign =
    [(Class)[self->_proxiedObject class] instanceMethodSignatureForSelector:sel];
    
    if (sign == nil)
    {
        sign = [NSMethodSignature signatureWithObjCTypes:(const char *)@encode(const char*)];
    }
    
    self->_justResponded = NO;
    
    return sign;
}

-(void)forwardInvocation:(NSInvocation*)invocation
{
    if (self->_proxiedObject == nil)
    {
        if (self->_logOnNoResponse)
        {
            NSLog(@"Warning: proxiedObject is nil! This is a debugging message!");
            return;
        }
        
    }//self->_proxiedObject == nil
    
    if ([self->_proxiedObject respondsToSelector:[invocation selector]])
    {
        [invocation invokeWithTarget:(id)self->_proxiedObject];
        _justResponded=YES;
    }
    else if (self->_logOnNoResponse)
    {
        NSLog(
              @"Object \"%@\" failed to respond to delegate message \"%@\"!" \
              "This is a debugging message.",
              [[self proxiedObject] class],
              NSStringFromSelector([invocation selector]));
    }
    
}


-(id)proxiedObject
{
    return self->_proxiedObject;
}
-(void)setProxiedObject:(id)proxied
{
    /**
     *  Not retained to avoid retain cycles
     */
    self->_proxiedObject = proxied;
}

-(BOOL)justResponded
{
    return self->_justResponded;
}

-(void)setLogOnNoResponse:(BOOL)log
{
    self->_logOnNoResponse = log;
}
-(BOOL)logOnNoResponse
{
    return self->_logOnNoResponse;
}

@end
