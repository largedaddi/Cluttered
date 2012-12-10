// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ListItem.m instead.

#import "_ListItem.h"

const struct ListItemAttributes ListItemAttributes = {
	.complete = @"complete",
	.details = @"details",
};

const struct ListItemRelationships ListItemRelationships = {
	.list = @"list",
};

const struct ListItemFetchedProperties ListItemFetchedProperties = {
};

@implementation ListItemID
@end

@implementation _ListItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ListItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ListItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ListItem" inManagedObjectContext:moc_];
}

- (ListItemID*)objectID {
	return (ListItemID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"completeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"complete"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic complete;



- (BOOL)completeValue {
	NSNumber *result = [self complete];
	return [result boolValue];
}

- (void)setCompleteValue:(BOOL)value_ {
	[self setComplete:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveCompleteValue {
	NSNumber *result = [self primitiveComplete];
	return [result boolValue];
}

- (void)setPrimitiveCompleteValue:(BOOL)value_ {
	[self setPrimitiveComplete:[NSNumber numberWithBool:value_]];
}





@dynamic details;






@dynamic list;

	






@end
