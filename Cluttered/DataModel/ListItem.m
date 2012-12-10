#import "ListItem.h"
#import "List.h"

@implementation ListItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
                           details:(NSString *)details_
                          complete:(BOOL)complete_ {
  ListItem *listItem = [ListItem insertInManagedObjectContext:moc_];
  listItem.details = details_;
  listItem.complete = [NSNumber numberWithBool:complete_];
  return listItem;
}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
                           details:(NSString *)details_
                          complete:(BOOL)complete_
                              list:(List *)list_ {
  ListItem *listItem = [ListItem insertInManagedObjectContext:moc_
                                                      details:details_
                                                     complete:complete_];
  listItem.list = list_;
  return listItem;
}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ withList:(List *)list_ {
  ListItem *listItem = [ListItem insertInManagedObjectContext:moc_];
  listItem.list = list_;
  return listItem;
}

@end
