//
//  CQMDelegateManager.h
//  TrialAndError
//
//  Created by sanooj_s on 6/2/14.
//  Copyright (c) 2014 sanooj_s. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQMDelegateManager : NSProxy
{
	id _proxiedObject;
	BOOL _justResponded,_logOnNoResponse;
}

-(void)forwardInvocation:(NSInvocation*)invocation;

-(id)proxiedObject;
-(void)setProxiedObject:(id)proxied;

-(BOOL)justResponded;

-(void)setLogOnNoResponse:(BOOL)log;
-(BOOL)logOnNoResponse;

@end


