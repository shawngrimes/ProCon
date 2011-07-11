// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ArgumentClass.h instead.

#import <CoreData/CoreData.h>


@class ProjectClass;




@interface ArgumentClassID : NSManagedObjectID {}
@end

@interface _ArgumentClass : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ArgumentClassID*)objectID;



@property (nonatomic, retain) NSString *argDescription;

//- (BOOL)validateArgDescription:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *score;

@property short scoreValue;
- (short)scoreValue;
- (void)setScoreValue:(short)value_;

//- (BOOL)validateScore:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) ProjectClass* project;
//- (BOOL)validateProject:(id*)value_ error:(NSError**)error_;




@end

@interface _ArgumentClass (CoreDataGeneratedAccessors)

@end

@interface _ArgumentClass (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveArgDescription;
- (void)setPrimitiveArgDescription:(NSString*)value;


- (NSNumber*)primitiveScore;
- (void)setPrimitiveScore:(NSNumber*)value;

- (short)primitiveScoreValue;
- (void)setPrimitiveScoreValue:(short)value_;




- (ProjectClass*)primitiveProject;
- (void)setPrimitiveProject:(ProjectClass*)value;


@end
