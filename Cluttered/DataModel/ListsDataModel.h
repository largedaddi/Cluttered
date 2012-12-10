//
//  ListsDataModel.h
//  Cluttered
//
//  Created by Sean Pilkenton on 10/15/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ListsDataModel : NSObject

+ (id)sharedDataModel;

@property(nonatomic, readonly) NSManagedObjectContext *mainContext;
@property(nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)modelName;
- (NSString *)pathToModel;
- (NSString *)storeFileName;
- (NSString *)pathToLocalStore;

@end
