// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ProjectClass.m instead.

#import "_ProjectClass.h"

@implementation ProjectClassID
@end

@implementation _ProjectClass

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Project";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Project" inManagedObjectContext:moc_];
}

- (ProjectClassID*)objectID {
	return (ProjectClassID*)[super objectID];
}




@dynamic lastModified;






@dynamic projectName;






@dynamic arguments;

	
- (NSMutableSet*)argumentsSet {
	[self willAccessValueForKey:@"arguments"];
	NSMutableSet *result = [self mutableSetValueForKey:@"arguments"];
	[self didAccessValueForKey:@"arguments"];
	return result;
}
	





@end
