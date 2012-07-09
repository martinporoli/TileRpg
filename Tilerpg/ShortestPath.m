//
//  ShortestPath.m
//  Tilerpg
//
//  Created by T2 on 7/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ShortestPath.h"


@interface ShortestPathStep : NSObject
{
	CGPoint position;
	int gScore;
	int hScore;
	ShortestPathStep *parent;
}

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) int gScore;
@property (nonatomic, assign) int hScore;
@property (nonatomic, assign) ShortestPathStep *parent;

- (id)initWithPosition:(CGPoint)pos;
- (int)fScore;

@end

@implementation ShortestPathStep

@synthesize position;
@synthesize gScore;
@synthesize hScore;
@synthesize parent;

- (id)initWithPosition:(CGPoint)pos
{
	if ((self = [super init])) {
		position = pos;
		gScore = 0;
		hScore = 0;
		parent = nil;
	}
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@  pos=[%.0f;%.0f]  g=%d  h=%d  f=%d", [super description], self.position.x, self.position.y, self.gScore, self.hScore, [self fScore]];
}

- (BOOL)isEqual:(ShortestPathStep *)other
{
	return CGPointEqualToPoint(self.position, other.position);
}

- (int)fScore
{
	return self.gScore + self.hScore;
}
@end

@interface ShortestPath ()
{
    NSMutableArray *spOpenSteps;
	NSMutableArray *spClosedSteps;
    CCTMXTiledMap *tileMap;
    CCTMXLayer *meta;    
}
@property (nonatomic,strong) NSMutableArray * spOpenSteps;
@property (nonatomic,strong) NSMutableArray * spClosedSteps;
@property (nonatomic,strong) CCTMXTiledMap * tileMap;
@property (nonatomic,strong) CCTMXLayer * meta;
@end
@implementation ShortestPath
{
    
}
@synthesize spOpenSteps = _spOpenSteps;
@synthesize spClosedSteps = _spClosedSteps;
@synthesize tileMap = _tileMap;
@synthesize meta = _meta;
-(id)initWithTiledMapNamed:(NSString*)tiledMapNamed collisionCheckAtLayerNamed:(NSString*)layerNamed
{
    if (self = [super init])
    {
        self.tileMap = [CCTMXTiledMap  tiledMapWithTMXFile:tiledMapNamed];
        self.meta = [_tileMap layerNamed:layerNamed];
        NSLog(@"init path");
        
    }
    return self;
}
- (BOOL)isValidTileCoord:(CGPoint)tileCoord {
    if (tileCoord.x < 0 || tileCoord.y < 0 || 
        tileCoord.x >= _tileMap.mapSize.width ||
        tileCoord.y >= _tileMap.mapSize.height) {
        return FALSE;
    } else {
        return TRUE;
    }
}

-(BOOL)isEligablePath:(CGPoint)tileCord
{
    int tileGid = [self.meta tileGIDAt:tileCord];
    if (tileGid) {
        NSDictionary *properties = [_tileMap propertiesForGID:tileGid];
        if (properties) {
            NSString *collision = [properties valueForKey:@"Collidable"];
            if (collision && [collision compare:@"True"] == NSOrderedSame) {
                return NO;
            }
            
        }
    }
    return YES;
}
-(NSArray*)moveToTileCord:(CGPoint)toTileCoord fromTileCord:(CGPoint)fromTileCoord
{
    NSLog(@"men ahla");
    if (CGPointEqualToPoint(fromTileCoord, toTileCoord)){
        NSString *CGPointAsString = [NSString stringWithFormat:@"{%0.1f,%0.1f}",fromTileCoord.x,fromTileCoord.y];
        return [[NSMutableArray alloc] initWithObjects:CGPointAsString, nil];
    }
    self.spOpenSteps = [[NSMutableArray alloc] init];
    self.spClosedSteps = [[NSMutableArray alloc] init];
    // Start by adding the from position to the open list
    NSLog(@"yo");
    [self insertInOpenSteps:[[[ShortestPathStep alloc] initWithPosition:fromTileCoord] autorelease]];
    do {
        // Get the lowest F cost step
        // Because the list is ordered, the first step is always the one with the lowest F cost
        ShortestPathStep *currentStep = [_spOpenSteps objectAtIndex:0];
        
        // Add the current step to the closed set
        [_spClosedSteps addObject:currentStep];
        
        // Remove it from the open list
        // Note that if we wanted to first removing from the open list, care should be taken to the memory
        [_spOpenSteps removeObjectAtIndex:0];
        
        // If the currentStep is the desired tile coordinate, we are done!
        if (CGPointEqualToPoint(currentStep.position, toTileCoord)) {
            
            ShortestPathStep *tmpStep = currentStep;
            
            NSMutableArray *steps = [[NSMutableArray alloc] init ];
            do {
                NSString *CGPointAsString = [NSString stringWithFormat:@"{%0.1f,%0.1f}",tmpStep.position.x,tmpStep.position.y];
                [steps addObject:CGPointAsString];
                tmpStep = tmpStep.parent; // Go backward
            } while (tmpStep != nil); // Until there is not more parent
            
            _spOpenSteps = nil; // Set to nil to release unused memory
            _spClosedSteps = nil; // Set to nil to release unused memory
            //return reversed array
            return [[steps reverseObjectEnumerator]allObjects];
        }
        
        // Get the adjacent tiles coord of the current step
        NSArray *adjSteps = [self walkableAdjacentTilesCoordForTileCoord:currentStep.position];
        for (NSValue *v in adjSteps) {
            ShortestPathStep *step = [[ShortestPathStep alloc] initWithPosition:[v CGPointValue]];
            
            // Check if the step isn't already in the closed set 
            if ([_spClosedSteps containsObject:step]) {
                [step release]; // Must releasing it to not leaking memory ;-)
                continue; // Ignore it
            }		
            
            // Compute the cost from the current step to that step
            int moveCost = [self costToMoveFromStep:currentStep toAdjacentStep:step];
            
            // Check if the step is already in the open list
            NSUInteger index = [_spOpenSteps indexOfObject:step];
            
            if (index == NSNotFound) { // Not on the open list, so add it
                
                // Set the current step as the parent
                step.parent = currentStep;
                
                // The G score is equal to the parent G score + the cost to move from the parent to it
                step.gScore = currentStep.gScore + moveCost;
                
                // Compute the H score which is the estimated movement cost to move from that step to the desired tile coordinate
                step.hScore = [self computeHScoreFromCoord:step.position toCoord:toTileCoord];
                
                // Adding it with the function which is preserving the list ordered by F score
                [self insertInOpenSteps:step];
                
                // Done, now release the step
                [step release];
            }
            else { // Already in the open list
                
                [step release]; // Release the freshly created one
                step = [_spOpenSteps objectAtIndex:index]; // To retrieve the old one (which has its scores already computed ;-)
                
                // Check to see if the G score for that step is lower if we use the current step to get there
                if ((currentStep.gScore + moveCost) < step.gScore) {
                    
                    // The G score is equal to the parent G score + the cost to move from the parent to it
                    step.gScore = currentStep.gScore + moveCost;
                    
                    // Because the G Score has changed, the F score may have changed too
                    // So to keep the open list ordered we have to remove the step, and re-insert it with
                    // the insert function which is preserving the list ordered by F score
                    
                    // We have to retain it before removing it from the list
                    [step retain];
                    
                    // Now we can removing it from the list without be afraid that it can be released
                    [_spOpenSteps removeObjectAtIndex:index];
                    
                    // Re-insert it with the function which is preserving the list ordered by F score
                    [self insertInOpenSteps:step];
                    
                    // Now we can release it because the oredered list retain it
                    [step release];
                }
            }
        }
        
    } while ([_spOpenSteps count] > 0);
    return nil;
}
- (void)insertInOpenSteps:(ShortestPathStep *)step
{
	int stepFScore = [step fScore]; // Compute the step's F score
	int count = [_spOpenSteps count];
	int i = 0; // This will be the index at which we will insert the step
	for (; i < count; i++) {
		if (stepFScore <= [[_spOpenSteps objectAtIndex:i] fScore]) { // If the step's F score is lower or equals to the step at index i
			// Then we found the index at which we have to insert the new step
            // Basically we want the list sorted by F score
			break;
		}
	}
	// Insert the new step at the determined index to preserve the F score ordering
	[_spOpenSteps insertObject:step atIndex:i];
}

// Compute the H score from a position to another (from the current position to the final desired position
- (int)computeHScoreFromCoord:(CGPoint)fromCoord toCoord:(CGPoint)toCoord
{
	// Here we use the Manhattan method, which calculates the total number of step moved horizontally and vertically to reach the
	// final desired step from the current step, ignoring any obstacles that may be in the way
	return abs(toCoord.x - fromCoord.x) + abs(toCoord.y - fromCoord.y);
}

// Compute the cost of moving from a step to an adjacent one
- (int)costToMoveFromStep:(ShortestPathStep *)fromStep toAdjacentStep:(ShortestPathStep *)toStep
{
	// Because we can't move diagonally and because terrain is just walkable or unwalkable the cost is always the same.
	// But it have to be different if we can move diagonally and/or if there is swamps, hills, etc...
	return 1;
}
- (NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord
{
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:4];
    
	// Top
	CGPoint p = CGPointMake(tileCoord.x, tileCoord.y - 1);
	if ([self isValidTileCoord:p] && [self isEligablePath:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	// Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y);
	if ([self isValidTileCoord:p] && [self isEligablePath:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	// Bottom
	p = CGPointMake(tileCoord.x, tileCoord.y + 1);
	if ([self isValidTileCoord:p] && [self isEligablePath:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	// Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y);
	if ([self isValidTileCoord:p] && [self isEligablePath:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	return [NSArray arrayWithArray:tmp];
}@end