//
//  CQMMetadataExtraction.m
//  TrialAndError
//
//  Created by sanooj_s on 5/16/14.
//  Copyright (c) 2014 sanooj_s. All rights reserved.
//

#import "CQMMetadataExtraction.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CQMMetadataExtraction

-(NSString*)exceptionTester
{
    
    NSString* myWord;
    myWord = @"myWord";

    NS_DURING
    
    
    NSException *localException;
    localException = [[NSException alloc] initWithName:@"ExceptionName" reason:@"F*ck's Sake" userInfo:nil];
    
    [localException raise];
    
    
    
    
    NS_HANDLER
    if  ([[localException name ]isEqualToString:@"ExceptionName "])
    {
        NS_VALUERETURN(myWord,NSString*);
        //NS_VOIDRETURN; // returnsFromTryCatch
    }
    
    else
    {
        //[localException raise];
    }
    NS_ENDHANDLER
    
    //return @"sdff";
    
    NSLog(@"%@",myWord);
}

-(void)getImageMetadata
{
    ALAssetsLibrary* assetsLib;
    assetsLib = [ALAssetsLibrary new];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock assetLibGroupEnumerationBlk;
    assetLibGroupEnumerationBlk = ^(ALAssetsGroup *group, BOOL *stop)
    {
        NSLog(@"%@",[group valueForProperty:ALAssetsGroupPropertyName]);
        
        ALAssetsGroupEnumerationResultsBlock assetsGrpEnumerationResultsBlk;
        assetsGrpEnumerationResultsBlk =
        ^(ALAsset *result, NSUInteger index, BOOL *__stop)
        {
            NSLog(@"%@",result);
            
            NSLog(@"%@",[result valueForProperty:ALAssetPropertyAssetURL]);
            
            NSLog(@"%@",[[result defaultRepresentation] metadata]);
            
            *__stop = YES;
        };
        
        [group enumerateAssetsUsingBlock:assetsGrpEnumerationResultsBlk];
        
        *stop = YES;
        
    };

    ALAssetsLibraryAccessFailureBlock assetLibAccessFailureBlk;
    assetLibAccessFailureBlk   = ^(NSError *error)
    {
        
        
    };
    
    [assetsLib enumerateGroupsWithTypes:(ALAssetsGroupType)ALAssetsGroupSavedPhotos
                             usingBlock:assetLibGroupEnumerationBlk
                           failureBlock:assetLibAccessFailureBlk];
}


@end





#pragma mark
#pragma mark methodDeclarations - begin
#pragma mark
void NSUncaught_ExceptionHandler(NSException * exception);

ALAssetsLibrary*
getSharedAssetLibInstance(void);

ALAsset*
writeImageToAlbumAndReturnAsset(
                                UIImage* image,
                                NSError* __autoreleasing * errorSavingAsset,
                                ALAssetsLibrary* __autoreleasing * assetLibrary
                                );

NSArray* getBundleAndContents(void);
#pragma mark
#pragma mark methodDeclarations - end
#pragma mark
int __main(int argc, char * argv[])
{
    
    
    (void) NSSetUncaughtExceptionHandler(&NSUncaught_ExceptionHandler);
    
    NSLog(@"%@",[[[[[[NSDate date] description]
                    stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""]stringByReplacingOccurrencesOfString:@"+" withString:@""]);
    
    NSCharacterSet* charSet;
    charSet = [NSCharacterSet characterSetWithCharactersInString:@" :-+"];
    
    NSLog(@"%@",[[[NSDate date] description] componentsSeparatedByCharactersInSet:charSet]);
    
    NSLog(@"%@",[[[NSDate date] description] stringByTrimmingCharactersInSet:charSet]);
    
    NSLog(@"%@",[[[[NSDate date] description] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" :-+"]] componentsJoinedByString:@"" ]);
    
    //    @autoreleasepool
    //    {
    //        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    //    }
    //
    
    dispatch_queue_t customQ;
    customQ = dispatch_queue_create("test.upload.Q", DISPATCH_QUEUE_SERIAL);
    
    NSArray* imageArray;
    imageArray = getBundleAndContents();
    
    __block NSMutableArray* imageAssetsArray;
    imageAssetsArray = [NSMutableArray new];
    
    dispatch_apply([imageArray count], customQ, ^(size_t currentIndex) {
        
        
        @autoreleasepool {
            
            
            
            NSLog(@"Itration # %zu",currentIndex);
            
            ///*
            NSError* __autoreleasing error              = nil;
            ALAssetsLibrary* __autoreleasing assetsLib  = nil;
            ALAsset* assetReturned                      = nil;
            
            assetReturned =
            writeImageToAlbumAndReturnAsset
            (
             /* [UIImage imageNamed:@"punch.jpg"] */
             (UIImage*)[imageArray objectAtIndex:currentIndex],
             (NSError *__autoreleasing *)&error,
             (ALAssetsLibrary *__autoreleasing *)&assetsLib
             );
            
            NSLog(@"assetReturned %@",assetReturned);
            NSLog(@ "error O %@",error);
            
            //                           NSLog(@"createAssetGroupAndAddAsset %@",
            //                                 createAssetGroupAndAddAsset(assetReturned) ? @"YES" : @"NO");
            
        }//autoreleasePool
        
    });
    
    
    __block BOOL shouldKeepRunning = YES;
    
    [getSharedAssetLibInstance() enumerateGroupsWithTypes:(ALAssetsGroupType)ALAssetsGroupAlbum
                                               usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         //
         if ([[group valueForProperty:ALAssetsGroupPropertyName]  isEqualToString: @"BOOYAH"])
         {
             NSLog(@"%@" ,[group isEditable] ? @YES : @NO);
             
             
             [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
              {
                  if (result)
                  {
                      [imageAssetsArray addObject:result];
                      
                      NSLog(@" [[imageAssetsArray objectAtIndex:index] valueForProperty:ALAssetPropertyURLs] %@",[[imageAssetsArray objectAtIndex:index] valueForProperty:ALAssetPropertyURLs]);
                  }
                  
                  
              }];//enumerateAssetsWithOptions
             
             
             
             
             *stop = YES;
             shouldKeepRunning = NO;
             
             
         }
         
         
     }
                                             failureBlock:^(NSError *error)
     {
         
         NSLog(@"failed to enumerate group %@",error);
         shouldKeepRunning = NO;
         
     }];
    
    
    
    
    /**
     *  main threads run loop
     */
    NSRunLoop* currentRunLoop;
    currentRunLoop = [NSRunLoop currentRunLoop];
    
    /**
     *  Get Thread Name
     */
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    
    int count = 0;
    while (shouldKeepRunning)
    {
        NSLog(@"runloopCycle#: %d",count ++);
        if ([currentRunLoop runMode:NSDefaultRunLoopMode
                         beforeDate:[NSDate distantFuture]])
        {
            continue;
        }
        else
        {
            break;
        }
    }
    
    
    NSLog(@"imageAssetsArray    %@",imageAssetsArray);

   
    //[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeInterval:(NSTimeInterval)5 sinceDate:[NSDate date]]];
    

        return 0;
  
    

}

void NSUncaught_ExceptionHandler(NSException * exception)
{
    NSLog(@"[exception name] \n%@\n",[exception name]);
    NSLog(@"[exception reason] \n%@\n ",[exception reason]);
    NSLog(@"[exception callStackSymbols] \n%@\n ",[exception callStackSymbols]);
    return ;
}


ALAssetsLibrary*
getSharedAssetLibInstance(void)
{
    static ALAssetsLibrary* assetsLibrarySharedInstance = nil;
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^
                  {
                      if (assetsLibrarySharedInstance == nil)
                      {
                          assetsLibrarySharedInstance = [ALAssetsLibrary new];
                      }
                      
                  });
    
    return assetsLibrarySharedInstance;
}


ALAsset*
writeImageToAlbumAndReturnAsset
(
 UIImage* ,
 NSError* __autoreleasing * ,
 ALAssetsLibrary* __autoreleasing *
 );

ALAsset*
writeImageToAlbumAndReturnAsset(UIImage* image,NSError* __autoreleasing * errorSavingAsset,ALAssetsLibrary* __autoreleasing * assetLibrary
                                )
{
    __block BOOL shouldKeepRunning      = YES;
    __block NSError* errorSaving        = nil;
    __block ALAsset* assetSought        = nil;
    __block ALAssetsLibrary* assetLib   = nil;
    /**
     *  get The AssetLibrary
     */
    
    assetLib = getSharedAssetLibInstance();
    
    /**
     *  Asset Enumeration Q
     */
    dispatch_queue_t thisConcurrentQ = 0;
    thisConcurrentQ =
    dispatch_queue_create("this.Concurrent.QQ", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(thisConcurrentQ, ^{
        
        [assetLib writeImageToSavedPhotosAlbum:(CGImageRef)[image CGImage]
                                   orientation:
         (ALAssetOrientation)[image imageOrientation]
                               completionBlock:
         ^(NSURL *assetURL, NSError *error)
         {
             if (assetURL)
             {
                 /**
                  *  get the assetFrom url
                  */
                 [assetLib assetForURL:assetURL
                           resultBlock:
                  ^(ALAsset *asset)
                  {
                      assetSought = asset;
                      
                      BOOL createAssetGroupAndAddAsset(ALAsset* asset);
                      
                      //NSLog(@"createAssetGroupAndAddAsset %@",createAssetGroupAndAddAsset(assetSought) ? @"YES" : @"NO");
                      
                      [getSharedAssetLibInstance() addAssetsGroupAlbumWithName:@"BOOYAH" resultBlock:
                       ^(ALAssetsGroup *group)
                       {
                           NSLog(@"group %@",group);
                           
                           if (group == nil)
                           {
                               [getSharedAssetLibInstance() enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                                                          usingBlock:
                                ^(ALAssetsGroup *group, BOOL *stop)
                                {
                                    
                                    if ([[group valueForProperty:ALAssetsGroupPropertyName]  isEqualToString: @"BOOYAH"])
                                    {
                                        NSLog(@"%@" ,[group isEditable] ? @YES : @NO);
                                        NSLog(@"[group addAsset:assetSought] %@" ,[group addAsset:assetSought] ? @YES : @NO);
                                        
                                        *stop = YES;
                                        shouldKeepRunning = NO;
                                        
                                    }
                                }
                                                                        failureBlock:
                                ^(NSError *error)
                                {
                                    NSLog(@"enumerateGroupsWithTypes error %@",error);
                                    shouldKeepRunning = NO;
                                    
                                }];//enumerateGroupsWithTypes
                           }
                           else
                           {
                               if ([[group valueForProperty:ALAssetsGroupPropertyName]  isEqualToString: @"BOOYAH"])
                               {
                                   NSLog(@"%@" ,[group isEditable] ? @YES : @NO);
                                   
                                   NSLog(@"[group addAsset:assetSought] %@" ,[group addAsset:assetSought] ? @YES : @NO);
                               }
                               shouldKeepRunning = NO;
                               
                           }//group
                           
                           
                           
                       }
                                                                  failureBlock:
                       ^(NSError *error)
                       {
                           NSLog(@"error %@",error);
                           
                           shouldKeepRunning = NO;
                           
                       }]; //addAssetsGroupAlbumWithName
                      
                      //                 shouldKeepRunning = NO;
                  }
                          failureBlock:
                  ^(NSError *error)
                  {
                      errorSaving = error;
                      
                      shouldKeepRunning = NO;
                      
                  }];//assetForURL
             }
             else
             {
                 errorSaving = error;
                 
                 shouldKeepRunning = NO;
             }
             
         }];//writeImageToSavedPhotosAlbum
        
        
    });//dispatch_async new Q
    
    /**
     *  Wait on the current(main) runloop (thread from which this function was called) as asset operations happen asynchronously
     *  Start the infinite loop with a bool condition check
     *  Runs the loop once, blocking for input in the specified mode until a given date.
     * Run loop wil block all other inputs
     *
     * Can also be done in one step like this this will make the runlopp wiat for 5 sec
     
     [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
     beforeDate:
     [NSDate dateWithTimeInterval:5 sinceDate:[NSDate date]]];
     
     */
    
    
    /**
     *  main threads run loop
     */
    NSRunLoop* currentRunLoop;
    currentRunLoop = [NSRunLoop currentRunLoop];
    
    /**
     *  Get Thread Name
     */
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    
    int count = 0;
    while (shouldKeepRunning)
    {
        NSLog(@"runloopCycle#: %d",count ++);
        if ([currentRunLoop runMode:NSDefaultRunLoopMode
                         beforeDate:[NSDate distantFuture]])
        {
            continue;
        }
        else
        {
            break;
        }
    }
    
    
    
    if (errorSavingAsset != NULL)
    {
        *errorSavingAsset = errorSaving;
    }
    
    thisConcurrentQ = 0;
    return assetSought;
    
}//writeImageToAlbumAndReturnAsset




BOOL createAssetGroupAndAddAsset(ALAsset* asset)
{
    __block BOOL shouldKeepRunning      = YES;
    
    __block BOOL addAssetSuccess = NO;
    
    dispatch_queue_t that_ConcurrentQ = 0;
    that_ConcurrentQ =
    dispatch_queue_create("that.Concurrent.QQ", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(that_ConcurrentQ, ^{
        
        [getSharedAssetLibInstance() addAssetsGroupAlbumWithName:@"BOOYAH" resultBlock:
         ^(ALAssetsGroup *group)
         {
             NSLog(@"group %@",group);
             
             if (group == nil)
             {
                 [getSharedAssetLibInstance() enumerateGroupsWithTypes:ALAssetsGroupAlbum
                                                            usingBlock:
                  ^(ALAssetsGroup *group, BOOL *stop)
                  {
                      
                      if ([[group valueForProperty:ALAssetsGroupPropertyName]
                           isEqualToString: @"BOOYAH"])
                      {
                          NSLog(@"%@" ,[group isEditable] ? @YES : @NO);
                          //NSLog(@"%@" ,[group addAsset:asset] ? @YES : @NO);
                          
                          addAssetSuccess = [group addAsset:asset] ? YES : NO;
                          
                          
                          
                          
                          *stop = YES;
                          
                          shouldKeepRunning = NO;
                          
                      }
                  }
                                                          failureBlock:
                  ^(NSError *error)
                  {
                      NSLog(@"enumerateGroupsWithTypes error %@",error);
                      
                      shouldKeepRunning = NO;
                      
                  }];//enumerateGroupsWithTypes
             }
             else
             {
                 addAssetSuccess = [group addAsset:asset] ? YES : NO;
                 
                 shouldKeepRunning = NO;
                 
             }//group created
             
             
             
         }
                                                    failureBlock:
         ^(NSError *error)
         {
             NSLog(@"error %@",error);
             
             shouldKeepRunning = NO;
             
         }]; //addAssetsGroupAlbumWithName
        
        
    });//dispatch_async(that_ConcurrentQ
    
    
    /**
     *  main threads
     *  or caller thread
     */
    NSRunLoop* currentRunLoop;
    currentRunLoop = [NSRunLoop currentRunLoop];
    
    /**
     *  Get Thread Name
     */
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
    
    int count = 0;
    while (shouldKeepRunning)
    {
        NSLog(@"runloopCycle for %s #: %d",__func__ ,count ++);
        if ([currentRunLoop runMode:NSDefaultRunLoopMode
                         beforeDate:[NSDate distantFuture]])
        {
            continue;
        }
        else
        {
            break;
        }
    }
    
    
    
    
    return addAssetSuccess;
    
}//createAssetGroupAndAddAsset






//int main(int argc, char * argv[])
//{
//
//    dispatch_queue_t customQ;
//    customQ = dispatch_queue_create("test.upload.Q", DISPATCH_QUEUE_SERIAL);
//
////    for (int currentIndex = 0; currentIndex < 2  ; currentIndex++ )
////    {
//
//        dispatch_apply(10, customQ, ^(size_t currentIndex) {
//
//
//                       @autoreleasepool {
//
//
//
//                           NSLog(@"Itration # %zu",currentIndex);
//
//                           ///*
//                           NSError* __autoreleasing error              = nil;
//                           ALAssetsLibrary* __autoreleasing assetsLib  = nil;
//                           ALAsset* assetReturned                      = nil;
//
//                           assetReturned =
//                           writeImageToAlbumAndReturnAsset
//                           (
//                            [UIImage imageNamed:@"punch.jpg"],
//                            (NSError *__autoreleasing *)&error,
//                            (ALAssetsLibrary *__autoreleasing *)&assetsLib
//                            );
//
//                           NSLog(@"assetReturned %@",assetReturned);
//                           NSLog(@ "error O %@",error);
//
////                           NSLog(@"createAssetGroupAndAddAsset %@",
////                                 createAssetGroupAndAddAsset(assetReturned) ? @"YES" : @"NO");
//
//                       }//autoreleasePool
//
//        });
////}
//
//
//    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//    }
//}


NSArray* getBundleAndContents(void)
{
    /**
     *  name is abit misleading.
     *  It points to the sub directory inside the Images.Bundle which contains images.
     */
    NSString* imageBundleName;
    imageBundleName = @"Images.bundle/100 HD Cars Wallpapers 1920 X 1200";
    
    /**
     *  Path to .app Dir
     */
    NSString* resourcePath;
    //resourcePath = [[NSBundle bundleForClass:[self class]] resourcePath];
    //    NSArray *bundleArray;
    //    bundleArray = [NSBundle allBundles];
    resourcePath = [[NSBundle mainBundle] resourcePath];
    
    /**
     *  full path to the
     *  sub directory inside the Images.Bundle which contains images.
     */
    NSString* pathToImageBundle;
    pathToImageBundle = [resourcePath stringByAppendingPathComponent:imageBundleName];
    ////XCTAssert(pathToImageBundle, @"Images.bundle doesn't exist");
    
    
    NSArray* dirContentsArray = nil;
    NSError* error = nil;
    
    dirContentsArray =
    [[NSFileManager defaultManager]contentsOfDirectoryAtPath:pathToImageBundle
                                                       error:&error];
    
    
    NSMutableArray* imageArray = nil;
    imageArray = [NSMutableArray new];
    ////XCTAssert(dirContentsArray, @"No contents In Image array");
    
    if (!error)
    {
        [dirContentsArray enumerateObjectsUsingBlock:^
         (id obj, NSUInteger idx, BOOL *stop)
         {
             @autoreleasepool
             {
                 
                 
                 NSString* resourceFullPath;
                 resourceFullPath = [pathToImageBundle stringByAppendingPathComponent:(NSString *)obj];
                 
                 /**
                  *  Check if its a dir
                  */
                 BOOL isDir;
                 [[NSFileManager defaultManager]fileExistsAtPath:resourceFullPath isDirectory:&isDir];
                 
                 
                 if (!isDir)
                 {
                     NSLog(@"%@",resourceFullPath);
                     
                     UIImage* imageFromFile;
                     imageFromFile =
                     [UIImage imageWithContentsOfFile:resourceFullPath];
                     
                     [imageArray addObject:imageFromFile];
                 }
             }
         }];
        
    }
    
    return imageArray;
}//getBundleAndContents




