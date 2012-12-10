#import "_ListItem.h"
@class List;

@interface ListItem : _ListItem {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
                           details:(NSString *)details_
                          complete:(BOOL)complete_;
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
                           details:(NSString *)details_
                          complete:(BOOL)complete_
                              list:(List *)list_;
+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ withList:(List *)list_;
@end
