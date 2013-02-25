// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to List.h instead.

#import <CoreData/CoreData.h>


extern const struct ListAttributes {
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *details;
	__unsafe_unretained NSString *imagePath;
	__unsafe_unretained NSString *name;
} ListAttributes;

extern const struct ListRelationships {
	__unsafe_unretained NSString *listItems;
} ListRelationships;

extern const struct ListFetchedProperties {
} ListFetchedProperties;

@class ListItem;






@interface ListID : NSManagedObjectID {}
@end

@interface _List : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ListID*)objectID;




@property (nonatomic, strong) NSDate* date;


//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* details;


//- (BOOL)validateDetails:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* imagePath;


//- (BOOL)validateImagePath:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* listItems;

- (NSMutableSet*)listItemsSet;





@end

@interface _List (CoreDataGeneratedAccessors)

- (void)addListItems:(NSSet*)value_;
- (void)removeListItems:(NSSet*)value_;
- (void)addListItemsObject:(ListItem*)value_;
- (void)removeListItemsObject:(ListItem*)value_;

@end

@interface _List (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (NSString*)primitiveDetails;
- (void)setPrimitiveDetails:(NSString*)value;




- (NSString*)primitiveImagePath;
- (void)setPrimitiveImagePath:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveListItems;
- (void)setPrimitiveListItems:(NSMutableSet*)value;


@end
