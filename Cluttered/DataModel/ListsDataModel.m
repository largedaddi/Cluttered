//
//  ListsDataModel.m
//  Cluttered
//
//  Created by Sean Pilkenton on 10/15/12.
//  Copyright (c) 2012 Pilks. All rights reserved.
//

#import "ListsDataModel.h"

@interface ListsDataModel ()
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
- (NSString *)documentsDirectory;
@end

@implementation ListsDataModel

@synthesize mainContext = _mainContext, persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedDataModel {
  static ListsDataModel *instance = nil;
  if (instance == nil) {
    instance = [[ListsDataModel alloc] init];
  }
  return instance;
}

- (NSString *)modelName {
  return @"Lists";
}

- (NSString *)pathToModel {
  return [[NSBundle mainBundle] pathForResource:[self modelName] ofType:@"momd"];
}

- (NSString *)storeFileName {
  return [[self modelName] stringByAppendingPathExtension:@"sqlite"];
}

- (NSString *)pathToLocalStore {
  return [[self documentsDirectory] stringByAppendingPathComponent:[self storeFileName]];
}

- (NSString *)documentsDirectory {
  NSString *documentsDirectory = nil;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  documentsDirectory = [paths objectAtIndex:0];
  return documentsDirectory;
}

- (NSManagedObjectContext *)mainContext {
  if (_mainContext == nil) {
    _mainContext = [[NSManagedObjectContext alloc] init];
    _mainContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
  }
  return _mainContext;
}

- (NSManagedObjectModel *)managedObjectModel {
  if (_managedObjectModel == nil) {
    NSURL *momUrl = [NSURL fileURLWithPath:[self pathToModel]];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momUrl];
  }
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (_persistentStoreCoordinator == nil) {
    NSLog(@"SQLITE PATH STOREL %@", [self pathToLocalStore]);
    NSURL *storeUrl = [NSURL fileURLWithPath:[self pathToLocalStore]];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]
                                         initWithManagedObjectModel:[self managedObjectModel]];

    NSDictionary *options = @{
      NSMigratePersistentStoresAutomaticallyOption : @YES,
      NSInferMappingModelAutomaticallyOption : @YES
    };
    
    NSError *err = nil;
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                           configuration:nil
                                     URL:storeUrl
                                 options:options
                                   error:&err]) {
      NSDictionary *userInfo = @{ NSUnderlyingErrorKey : err };
      NSString *reason = @"Could not create persistent store.";
      NSException *exc = [NSException exceptionWithName:NSInternalInconsistencyException
                                                 reason:reason
                                               userInfo:userInfo];
      @throw exc;
    }
    
    _persistentStoreCoordinator = psc;
  }
  
  return _persistentStoreCoordinator;
}

@end
