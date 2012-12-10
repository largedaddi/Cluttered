// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ListItem.h instead.

#import <CoreData/CoreData.h>


extern const struct ListItemAttributes {
	__unsafe_unretained NSString *complete;
	__unsafe_unretained NSString *details;
} ListItemAttributes;

extern const struct ListItemRelationships {
	__unsafe_unretained NSString *list;
} ListItemRelationships;

extern const struct ListItemFetchedProperties {
} ListItemFetchedProperties;

@class List;




@interface ListItemID : NSManagedObjectID {}
@end

@interface _ListItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ListItemID*)objectID;




@property (nonatomic, strong) NSNumber* complete;


@property BOOL completeValue;
- (BOOL)completeValue;
- (void)setCompleteValue:(BOOL)value_;

//- (BOOL)validateComplete:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* details;


//- (BOOL)validateDetails:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) List* list;

//- (BOOL)validateList:(id*)value_ error:(NSError**)error_;





@end

@interface _ListItem (CoreDataGeneratedAccessors)

@end

@interface _ListItem (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveComplete;
- (void)setPrimitiveComplete:(NSNumber*)value;

- (BOOL)primitiveCompleteValue;
- (void)setPrimitiveCompleteValue:(BOOL)value_;




- (NSString*)primitiveDetails;
- (void)setPrimitiveDetails:(NSString*)value;





- (List*)primitiveList;
- (void)setPrimitiveList:(List*)value;


@end
