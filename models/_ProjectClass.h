// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ProjectClass.h instead.

#import <CoreData/CoreData.h>


@class ArgumentClass;




@interface ProjectClassID : NSManagedObjectID {}
@end

@interface _ProjectClass : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ProjectClassID*)objectID;



@property (nonatomic, retain) NSDate *lastModified;

//- (BOOL)validateLastModified:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *projectName;

//- (BOOL)validateProjectName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* arguments;
- (NSMutableSet*)argumentsSet;




@end

@interface _ProjectClass (CoreDataGeneratedAccessors)

- (void)addArguments:(NSSet*)value_;
- (void)removeArguments:(NSSet*)value_;
- (void)addArgumentsObject:(ArgumentClass*)value_;
- (void)removeArgumentsObject:(ArgumentClass*)value_;

@end

@interface _ProjectClass (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveLastModified;
- (void)setPrimitiveLastModified:(NSDate*)value;


- (NSString*)primitiveProjectName;
- (void)setPrimitiveProjectName:(NSString*)value;




- (NSMutableSet*)primitiveArguments;
- (void)setPrimitiveArguments:(NSMutableSet*)value;


@end
