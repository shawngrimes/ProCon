#import "ProjectClass.h"

@implementation ProjectClass

// Custom logic goes here.

-(NSNumber *) getDecisionScore{
    int scoreResult=0;
    for (ArgumentClass *argument in self.arguments) {
        scoreResult+=[[argument valueForKey:@"score"] integerValue];
    }
    return [NSNumber numberWithInt:scoreResult];
}

-(NSNumber *) getDecisionAbsScore{
    int scoreResult=0;
    for (ArgumentClass *argument in self.arguments) {
        scoreResult+=abs([[argument valueForKey:@"score"] integerValue]);
    }
    return [NSNumber numberWithInt:scoreResult];
}

@end
