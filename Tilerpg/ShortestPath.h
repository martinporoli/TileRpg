//
//  ShortestPath.h
//  Tilerpg
//
//  Created by T2 on 7/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ShortestPath : CCLayer {
    
}
-(id)initWithTiledMapNamed:(NSString*)tiledMapNamed collisionCheckAtLayerNamed:(NSString*)layerNamed;

-(NSArray*)moveToTileCord:(CGPoint)toTileCoord fromTileCord:(CGPoint)fromTileCoord;
@end
