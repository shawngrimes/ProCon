// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ArgumentClass.m instead.

#import "_ArgumentClass.h"

@implementation ArgumentClassID
@end

@implementation _ArgumentClass

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Argument" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Argument";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Argument" inManagedObjectContext:moc_];
}

- (ArgumentClassID*)objectID {
	return (ArgumentClassID*)[super objectID];
}




@dynamic argDescription;






@dynamic score;



- (short)scoreValue {
	NSNumber *result = [self score];
	return [result shortValue];
}

- (void)setScoreValue:(short)value_ {
	[self setScore:[NSNumber numberWithShort:value_]];
}

- (short)primitiveScoreValue {
	NSNumber *result = [self primitiveScore];
	return [result shortValue];
}

- (void)setPrimitiveScoreValue:(short)value_ {
	[self setPrimitiveScore:[NSNumber numberWithShort:value_]];
}





@dynamic project;

	





@end
