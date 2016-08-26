//
//  FECoreDataHelper.h
//  QRcode
//
//  Created by hzf on 16/8/17.
//  Copyright © 2016年 hzf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FECoreDataHelper : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator; //协调者

+ (instancetype)shareHelper;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
