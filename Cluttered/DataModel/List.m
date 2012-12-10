#import "List.h"

@implementation List

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
                              name:(NSString *)name_
                           details:(NSString *)details_ {
  List *list = [List insertInManagedObjectContext:moc_];
  list.name = name_;
  list.details = details_;
  list.date = [NSDate date];
  return list;
}

@end
