#import "_List.h"

@interface List : _List {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc_
                              name:(NSString *)name_
                           details:(NSString *)details_;

@end
