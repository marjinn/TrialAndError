//
//  CQMNSObject.h
//  TrialAndError
//
//  Created by sanooj_s on 6/2/14.
//  Copyright (c) 2014 sanooj_s. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQMDelegateManager.h"

@interface CQMNSObject : NSObject

{
    CQMDelegateManager* _delegate;
}

void createClass (void);

@end
