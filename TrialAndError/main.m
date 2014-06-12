//
//  main.m
//  TrialAndError
//
//  Created by sanooj_s on 5/16/14.
//  Copyright (c) 2014 sanooj_s. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CQMAppDelegate.h"
#import "CQMMetadataExtraction.h"
#import "CQMNSObject.h"

/**
 *  NSProxy subclass
 */



@interface TestClass : NSObject <NSCoding>

@property NSString* firstProp;
@property NSString* secondProp;

@end

@implementation TestClass

-(NSString *)description
{
    //NSLog(@"\n%@\n \n%@\n ",[self firstProp],[self secondProp]);
   return [NSString stringWithFormat:@"\n%@\n \n%@\n ",[self firstProp],[self secondProp]];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    
    [coder encodeObject:[self firstProp] forKey:@"firstProp"];
    [coder encodeObject:[self secondProp] forKey:@"secondProp"];
    
    return;

}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        [self setFirstProp:[coder decodeObjectForKey:@"firstProp"]];
        [self setSecondProp:[coder decodeObjectForKey:@"secondProp"]];
    }
    return self;
}



@end


void deepCopyExample (void);
void shallowCopyExample (void);
void deepCopyBetterExample (void);

void shallowCopyExample (void)
{
    TestClass * testClass = nil;
    testClass = [TestClass new];
    
    [testClass setFirstProp:@"firstOne"];
    [testClass setSecondProp:@"secondOne"];
    
    NSString* apple = @"apple";
    NSString* microsoft = @"microsoft";
    NSString* dell = @"dell";
    
    NSNumber* one = @1;
    NSNumber* two = @2;
    NSNumber* three = @3;
    
    
    
    NSMutableDictionary* dictOne = nil;
    dictOne = [NSMutableDictionary dictionaryWithDictionary:
               @{
                 apple     : one,
                 microsoft : two ,
                 dell      : three
                 }
               ];
    
    /**
     *  Shallow Copy
     */
    NSMutableDictionary* dictOneCopy = nil;
    dictOneCopy = [dictOne mutableCopy];
    
    [dictOne setValue:testClass forKey:dell];
    
    [testClass setFirstProp:@"thirdOne"];
    [testClass setSecondProp:@"fourthOne"];
    
    [dictOneCopy setValue:testClass forKey:dell];
    
    /**
     *  Value changes for both dictOne and dictOne copy
     */
    NSLog(@"dictOne %@",[dictOne valueForKey:dell]);
    NSLog(@"dictOneCopy %@",[dictOneCopy valueForKey:dell]);
}

int main(int argc, char * argv[])
{
 
    createClass();
    
    CQMMetadataExtraction* metadataExtr;
    metadataExtr = [CQMMetadataExtraction new];
    
    //[metadataExtr getImageMetadata];
   // NSLog(@"BLOHHAHA %@",[metadataExtr exceptionTester]);
    
//    shallowCopyExample();
//    deepCopyExample();
//    deepCopyBetterExample();

#ifdef DEBUG
#define QPLog(__FORMAT__, ...) NSLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define QPLog(__FORMAT__, ...)
#endif
    
    
    QPLog("%s",@encode(int*));
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([CQMAppDelegate class]));
    }
}


void deepCopyExample (void)
{
    TestClass * testClass = nil;
    testClass = [TestClass new];
    
    [testClass setFirstProp:@"firstOne"];
    [testClass setSecondProp:@"secondOne"];
    
    NSString* apple = @"apple";
    NSString* microsoft = @"microsoft";
    NSString* dell = @"dell";
    
    NSNumber* one = @1;
    NSNumber* two = @2;
    NSNumber* three = @3;
    
    NSMutableDictionary* dictOne = nil;
    dictOne = [NSMutableDictionary dictionaryWithDictionary:
               @{
                 apple     : one,
                 microsoft : two ,
                 dell      : three
                 }
               ];
    
    /**
     * Deep Copy Using NSkeyedArchiver
     */
    
    /**
     *  This makes a deep copy of dictOne(all pointer dereferenced) and converts it to data
     */
    NSData* dictOneData = nil;
    if (dictOne && [dictOne count]>0)
    {
        @try
        {
            dictOneData = [NSKeyedArchiver archivedDataWithRootObject:(id)dictOne];
        }
        @catch (NSException *exception)
        {
            dictOneData = [NSData data];
        }
        @finally
        {
            
        }
        
    }
    /**
     *  get the archived dict and assign it to another dict
     */
    NSMutableDictionary* dictOneCopy = nil;
    
    if (dictOneData && [dictOneData length] > 0)
    {
        @try
        {
            dictOneCopy =
            (NSMutableDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:dictOneData];
        }
        @catch (NSException *exception)
        {
            dictOneCopy = [NSMutableDictionary dictionary];
        }
        @finally
        {
            
        }
        
    }
    
    /**
     *  Now dict One and Dict Copy both has same contents
     */

    NSLog(@"dictOne %@",dictOne);
    NSLog(@"dictOneCopy %@",dictOneCopy);
    
    /*
     2014-05-27 18:22:16.477 TrialAndError[58192:90b] dictOne {
     apple = 1;
     dell = 3;
     microsoft = 2;
     }
     2014-05-27 18:22:16.483 TrialAndError[58192:90b] dictOneCopy {
     apple = 1;
     dell = 3;
     microsoft = 2;
     }
     */
    
    /**
     *  Edit the first Dict
     */
    [dictOne setValue:testClass forKey:dell];
    
    NSLog(@"dictOne %@",dictOne);
    NSLog(@"dictOneCopy %@",dictOneCopy);
    
    /**
     *  change the TestClass properties
     *
     */
    [testClass setFirstProp:@"thirdOne"];
    [testClass setSecondProp:@"fourthOne"];
    
    //[dictOneCopy setValue:testClass forKey:dell];
    
    /*
     * Expected result is 
     *   dictOne should have old Values
     *   dictOnecopy should have the new values
     */
    
    /**
     *
     */
    NSLog(@"dictOne %@",[dictOne valueForKey:dell]);
    NSLog(@"dictOneCopy %@",[dictOneCopy valueForKey:dell]);
    

}


void deepCopyBetterExample (void)
{
    TestClass * testClass = nil;
    testClass = [TestClass new];
    
    [testClass setFirstProp:@"firstOne"];
    [testClass setSecondProp:@"secondOne"];
    
    NSString* apple = @"apple";
    NSString* microsoft = @"microsoft";
    NSString* dell = @"dell";
    
    NSNumber* one = @1;
    NSNumber* two = @2;
    NSNumber* three = @3;
    
    NSMutableDictionary* dictOne = nil;
    dictOne = [NSMutableDictionary dictionaryWithDictionary:
               @{
                 apple     : one,
                 microsoft : two ,
                 dell      : three
                 }
               ];
    
    /**
     * Deep Copy Using NSkeyedArchiver
     */
    
    /**
     *  This makes a deep copy of dictOne(all pointer dereferenced) and converts it to data
     */
    
    [dictOne setObject:testClass forKey:@"dell"];
    
    NSData* dictOneData = nil;
    if (dictOne && [dictOne count]>0)
    {
        @try
        {
            dictOneData = [NSKeyedArchiver archivedDataWithRootObject:(id)dictOne];
        }
        @catch (NSException *exception)
        {
            dictOneData = [NSData data];
        }
        @finally
        {
            
        }
        
    }
    /**
     *  get the archived dict and assign it to another dict
     */
    NSMutableDictionary* dictOneCopy = nil;
    
    if (dictOneData && [dictOneData length] > 0)
    {
        @try
        {
            dictOneCopy =
            (NSMutableDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:dictOneData];
        }
        @catch (NSException *exception)
        {
            dictOneCopy = [NSMutableDictionary dictionary];
        }
        @finally
        {
            
        }
        
    }
    
    /**
     *  Now dict One and Dict Copy both has same contents
     */
    
    NSLog(@"dictOne %@",dictOne);
    NSLog(@"dictOneCopy %@",dictOneCopy);
    
    /*
     2014-05-27 18:22:16.477 TrialAndError[58192:90b] dictOne {
     apple = 1;
     dell = 3;
     microsoft = 2;
     }
     2014-05-27 18:22:16.483 TrialAndError[58192:90b] dictOneCopy {
     apple = 1;
     dell = 3;
     microsoft = 2;
     }
     */
    
    /**
     *  Edit the first Dict
     */
    /**
     *  change the TestClass properties
     *
     */
    [testClass setFirstProp:@"thirdOne"];
    [testClass setSecondProp:@"fourthOne"];
    
    NSLog(@"dictOne %@",dictOne);
    NSLog(@"dictOneCopy %@",dictOneCopy);


}
