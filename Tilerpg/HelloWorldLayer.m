// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer
@implementation StatLayer
{
    CCLayer * layer;
    CCSprite * ruta;
    CCLabelTTF * statLabel;
}
-(id) init
{
    if (self = [super init])
    {
        ruta=[CCSprite spriteWithFile:@"statRuta.png"];
        statLabel=[CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(300, 300) hAlignment:CCTextAlignmentLeft lineBreakMode:CCLineBreakModeMiddleTruncation fontName:@"Helvetica-Bold" fontSize:25];
        statLabel.color=ccc3(0,0,0);
        [self addChild:ruta];
        [self addChild:statLabel];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        [ruta setScaleX: size.width/1024];
        [ruta setScaleY: size.height/768];
        [statLabel setScaleX: size.width/1024];
        [statLabel setScaleY: size.height/768];
        
    }
    return self;
}
-(void)showRuta:(CGPoint)point:(int)newEnergy:(int)newMoney:(int)newInt:(int)newStr:(int)newCha:(int)newDay
{
    NSString * statString = [NSString stringWithFormat:@"Energy:\t%i\nMoney:\t%i\nIntelligence:\t%i\nStrength:\t%i\nCharm:\t%i\nDay:\t%i",newEnergy,newMoney,newInt,newStr,newCha,newDay];
    [statLabel setString:statString];
    ruta.position=point;
    statLabel.position=point;
}
@end
// HelloWorldLayer implementation
@implementation HelloWorldLayer
{
    CCTMXTiledMap * tileMap;
    CCTMXLayer * background;
    CCTMXLayer * foreground;
    CCTMXLayer * meta;
    CCSprite *player;
    int playerWalk,jumpAble,chestMoney;
    int money,Int,Str,Cha,energy,days,raise;
    StatLayer * stats;
    CGPoint viewPoint;
    CCMenu *menu;
    CGSize size;
    CCLabelTTF *pratLabel;
    CCSprite *pratBubbla;
    CCMenu * pratMenu;
    CCLabelTTF *Op1;
    CCLabelTTF *Op2;
    int PratID;
}

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.agh
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        CCMenuItem *item1 = [CCMenuItemImage itemWithNormalImage:@"newGame.png" selectedImage:@"newGame2.png" target:self selector:@selector(newGame:)];
        CCMenuItem *item2 = [CCMenuItemImage itemWithNormalImage:@"loadGame.png" selectedImage:@"loadGame2.png" target:self selector:@selector(loadGame:)];
        menu = [CCMenu menuWithItems:item1, item2, nil];
        [menu alignItemsVertically];
        [self addChild:menu];
        size = [[CCDirector sharedDirector] winSize];
        pratBubbla = [CCSprite spriteWithFile:@"storBubbla.png"];
        [self addChild:pratBubbla];
        pratBubbla.position = ccp(-300,-300);
        pratLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(500, 175) hAlignment:CCTextAlignmentCenter lineBreakMode:CCLineBreakModeMiddleTruncation fontName:@"Helvetica-Bold" fontSize:25.0];
        pratLabel.color = ccc3(0, 0, 0);
        [self addChild:pratLabel];
        Op1 = [CCLabelTTF labelWithString:@"Cool Story Bro" fontName:@"Helvetica-Bold" fontSize:25];
        Op2 = [CCLabelTTF labelWithString:@"Cool Story Bro" fontName:@"Helvetica-Bold" fontSize:25];
        Op1.color=ccc3(255,0,0);
        Op2.color=ccc3(255,0,0);
        CCMenuItem *item3 = [CCMenuItemLabel itemWithLabel:Op1 target:self selector:@selector(Option1:)];
        CCMenuItem *item4 = [CCMenuItemLabel itemWithLabel:Op2 target:self selector:@selector(Option2:)];
        pratMenu = [CCMenu menuWithItems:item3, item4, nil];
        [pratMenu alignItemsVertically];
        [self addChild:pratMenu];
        pratMenu.position=ccp(-500,-500);
        [pratBubbla setScaleX:size.width/1024];
        [pratBubbla setScaleY:size.height/768];
        [pratLabel setScaleX:size.width/1024];
        [pratLabel setScaleY:size.height/768];
        [pratMenu setScaleX:size.width/1024];
        [pratMenu setScaleY:size.height/768];
    }
	return self;
}

-(void)newGame:(id)sender{
    money=0;
    Int=0;
    Str=0;
    Cha=0;
    energy=100;
    days=1;
    
    stats = [StatLayer node];
    [self addChild:stats];
    tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"World1.tmx"];
    background = [tileMap layerNamed:@"background"];
    foreground = [tileMap layerNamed:@"foreground"];
    meta = [tileMap layerNamed:@"Meta"];
    meta.visible=NO;
    [self addChild:tileMap z:-1];
    player = [CCSprite spriteWithFile:@"gubbe.png"];
    
    CCTMXObjectGroup *objects = [tileMap objectGroupNamed:@"Objects"];
    NSAssert(objects != nil, @"'Objects' object group not found");
    NSMutableDictionary *spawnPoint = [objects objectNamed:@"SpawnPoint"];        
    NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
    int x = [[spawnPoint valueForKey:@"x"] intValue];
    int y = [[spawnPoint valueForKey:@"y"] intValue];
    
    player.position = ccp(x, y);
    [self addChild:player]; 
    
    [self setViewpointCenter:player.position];
    self.isTouchEnabled = YES;
    [self removeChild:menu cleanup:YES];
}
-(void)loadGame:(id)sender{
    NSLog(@"load the fuckin game");
}

-(void)Option1:(id)sender{
    if(PratID==0)
    {
        if(Int>=25)
        {
            raise+=1;
            [self stringChanged:@"Now you're a Regular Janitor!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"You need 25 Intelligence for a raise" :@"" :@"" :-1];
        }
    }
    if(PratID==1)
    {
        if(Int>=50)
        {
            raise+=1;
            [self stringChanged:@"Now you're the Cheif Janitor!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"You need 50 Intelligence for a raise" :@"" :@"" :-1];
        }
    }
    if(PratID==2)
    {
        if(Int>=90)
        {
            raise+=1;
            [self stringChanged:@"Now you're an assistant!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"You need 90 Intelligence for a raise" :@"" :@"" :-1];
        }
    }
    if(PratID==3)
    {
        if(Int>=135)
        {
            raise+=1;
            [self stringChanged:@"Now you're a junior copywriter!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"You need 135 Intelligence for a raise" :@"" :@"" :-1];
        }
    }
    if(PratID==4)
    {
        if(Int>=180)
        {
            raise+=1;
            [self stringChanged:@"Now you're a software engineer!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"You need 180 Intelligence for a raise" :@"" :@"" :-1];
        }
    }
    if(PratID==5)
    {
        if(Int>=230)
        {
            raise+=1;
            [self stringChanged:@"Now you're the product manager!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"You need 230 Intelligence for a raise" :@"" :@"" :-1];
        }
    }
    if(PratID==6)
    {
        if(Int>=300)
        {
            raise+=1;
            [self stringChanged:@"Now you're the vice president of the company!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"You need 300 Intelligence for a raise" :@"" :@"" :-1];
        }
    }
    if(PratID==7)
    {
        if(Int>=360)
        {
            raise+=1;
            [self stringChanged:@"Now you're the president of the company!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"You need 360 Intelligence for a raise" :@"" :@"" :-1];
        }
    }
    if(PratID==8)
    {
        [self stringChanged:@"You're already the president" :@"" :@"" :-1];
    }
}
-(void)Option2:(id)sender{
    if(PratID<=8)
    {
        [self hideBubbla];
    }
}


-(void)stringChanged:(NSString*)prat:(NSString*)alt1:(NSString*)alt2:(int)pratID
{
    [pratLabel setString:prat];
    [Op1 setString:alt1];
    [Op2 setString:alt2];
    PratID=pratID;
}
-(void)showBubbla:(CGPoint)point;
{
    size = [[CCDirector sharedDirector] winSize];
    pratBubbla.position = point;
    pratLabel.position =point;
    pratMenu.position = point;
}
-(void)hideBubbla
{
    pratBubbla.position = ccp(-300,-300);
    pratLabel.position = ccp(-100,-100);
    pratMenu.position = ccp(-500,-500);
}


-(void)loadWorld:(NSString*)world:spawn
{
    tileMap = [CCTMXTiledMap tiledMapWithTMXFile:world];
    background = [tileMap layerNamed:@"background"];
    foreground = [tileMap layerNamed:@"foreground"];
    meta = [tileMap layerNamed:@"Meta"];
    meta.visible=NO;
    [self addChild:tileMap z:-1];
    
    CCTMXObjectGroup *objects = [tileMap objectGroupNamed:@"Objects"];
    NSAssert(objects != nil, @"'Objects' object group not found");
    NSMutableDictionary *spawnPoint = [objects objectNamed:spawn];        
    NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
    int x = [[spawnPoint valueForKey:@"x"] intValue];
    int y = [[spawnPoint valueForKey:@"y"] intValue];
    
    player.position = ccp(x, y);
}

-(void)unloadWorld
{
    [self removeChild:tileMap cleanup:YES];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    int x = position.x / tileMap.tileSize.width;
    int y = ((tileMap.mapSize.height * tileMap.tileSize.height) - position.y) / tileMap.tileSize.height;
    return ccp(x, y);
}

-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (tileMap.mapSize.width * tileMap.tileSize.width) 
            - winSize.width / 2);
    y = MIN(y, (tileMap.mapSize.height * tileMap.tileSize.height) 
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
    [stats showRuta:ccp(x+winSize.width/3,y+winSize.height/3-(40*winSize.height/768)):energy:money:Int:Str:Cha:days];
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                     priority:0 swallowsTouches:YES];
}//hejhej

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void)setPlayerPosition:(CGPoint)position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (tileMap.mapSize.width * tileMap.tileSize.width) 
            - winSize.width / 2);
    y = MIN(y, (tileMap.mapSize.height * tileMap.tileSize.height) 
            - winSize.height/2);
    
	CGPoint tileCoord = [self tileCoordForPosition:position];
    int tileGid = [meta tileGIDAt:tileCoord];
    if (tileGid) {
        NSDictionary *properties = [tileMap propertiesForGID:tileGid];
        if (properties) {
            NSString *home = [properties valueForKey:@"Home"];
            if (home && [home compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"home.tmx":@"SpawnPoint"];
                return;
            }
            NSString *ghome = [properties valueForKey:@"GirlsHome"];
            if (ghome && [ghome compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"GirlsHome.tmx":@"SpawnPoint"];
                return;
            }
            NSString *school = [properties valueForKey:@"School"];
            if (school && [school compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"school.tmx":@"SpawnPoint"];
                return;
            }
            NSString *coin = [properties valueForKey:@"Coin"];
            if (coin && [coin compare:@"True"] == NSOrderedSame) {
                if(chestMoney<5)
                {
                    money+=100;
                    chestMoney++;
                }
                else {
                    return;
                }
            }
            NSString *bar= [properties valueForKey:@"Bar"];
            if (bar && [bar compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"BarMap.tmx":@"SpawnPoint"];
                return;
            }
            NSString *Outbar= [properties valueForKey:@"outBar"];
            if (Outbar && [Outbar compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"World2.tmx":@"SpawnPointBar"];
                return;
            }
            
            NSString *outgHome= [properties valueForKey:@"OutGirlHome"];
            if (outgHome && [outgHome compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"World2.tmx":@"SpawnPointGirlHome"];
                return;
            }
            NSString *outSchool= [properties valueForKey:@"OutSchool"];
            if (outSchool && [outSchool compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"World2.tmx":@"SpawnPointSchool"];
                return;
            }
            NSString *job= [properties valueForKey:@"Job"];
            if (job && [job compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"Job.tmx":@"SpawnPoint"];
                return;
            }
            NSString *Outjob= [properties valueForKey:@"OutJob"];
            if (Outjob && [Outjob compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"World2.tmx":@"SpawnPointJob"];
                return;
            }
            NSString *Shop = [properties valueForKey:@"Shop"];
            if (Shop && [Shop compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"shop.tmx":@"SpawnPoint"];
                return;
            }
            NSString *OutShop = [properties valueForKey:@"OutShop"];
            if (OutShop && [OutShop compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"World2.tmx":@"SpawnPointShop"];
                return;//gygtfv
            }
            
            NSString *jump = [properties valueForKey:@"jump"];
            if (jump && [jump compare:@"True"] == NSOrderedSame) {
                if(jumpAble==0)
                {
                    if(energy>=5)
                    {
                        energy-=5;
                    }
                    else {
                        return;
                    }
                }
                else{
                    
                }
            }
            NSString *drink = [properties valueForKey:@"Drinking"];
            if (drink && [drink compare:@"True"] == NSOrderedSame) {
                if(energy>19)
                {
                    [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"GubbeDricker.png"]];                    energy-=20;
                    Cha+=5;
                }
            }
            NSString *work = [properties valueForKey:@"Work"];
            if (work && [work compare:@"True"] == NSOrderedSame) {
                if(energy>=25)
                {
                    [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"GubbePluggar.png"]];                    energy-=25;
                    if(raise==0)
                    {
                        money+=20;
                    }
                    if(raise==1)
                    {
                        money+=45;
                    }
                    if(raise==2)
                    {
                        money+=90;
                    }
                    if(raise==3)
                    {
                        money+=150;
                    }
                    if(raise==4)
                    {
                        money+=250;
                    }
                    if(raise==5)
                    {
                        money+=500;
                    }
                }
            }
            NSString *work2 = [properties valueForKey:@"JobTalk"];
            if (work2 && [work2 compare:@"True"] == NSOrderedSame) {
                [prat showBubbla:ccp(x-winSize.width/4+(30*winSize.width/1024),y+winSize.height/4+(60*winSize.height/768))];
                [prat stringChanged:@"What do you want?":@"":@"Nothing"];
            }
            
        NSString *girlTalk = [properties valueForKey:@"GirlTalk"];
        if (girlTalk && [girlTalk compare:@"True"] == NSOrderedSame) {
            [prat showBubbla:ccp(x-winSize.width/4+(30*winSize.width/1024),y+winSize.height/4+(60*winSize.height/768))];
            [prat stringChanged:@"Hi boy!":@"You´re pretty" :@"Wanna hang?"];
        }
            

            
            NSString *study = [properties valueForKey:@"study"];
            if (study && [study compare:@"True"] == NSOrderedSame) {
                if(energy>19)
                {
                    [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"GubbePluggar.png"]];                    energy-=20;
                    Int+=5;
                }
            }
            NSString *schoolTalk = [properties valueForKey:@"SchoolTalk"];
            if (schoolTalk && [schoolTalk compare:@"True"] == NSOrderedSame) {
                [self showBubbla:ccp(x-winSize.width/4+(30*winSize.width/1024),y+winSize.height/4+(60*winSize.height/768))];
                [self stringChanged:@"Welcome! You need tutoring?":@"Tutor me!":@"Naw i'm good":8];

            }
            NSString *barTalk = [properties valueForKey:@"BarTalk"];
            if (barTalk && [barTalk compare:@"True"] == NSOrderedSame) {
                [self showBubbla:ccp(x-winSize.width/4+(30*winSize.width/1024),y+winSize.height/4+(60*winSize.height/768))];
                [self stringChanged:@"You like beer?":@"Drink":@"Drink more":9];
            }
            NSString *shopTalk = [properties valueForKey:@"ShopTalk"];
            if (shopTalk && [shopTalk compare:@"True"] == NSOrderedSame) {
                [self showBubbla:ccp(x-winSize.width/4+(30*winSize.width/1024),y+winSize.height/4+(60*winSize.height/768))];
                [self stringChanged:@"What would you like?":@"You baby grr":@"A handmade superblastergun":10];
            }
            NSString *workOut = [properties valueForKey:@"strength"];
            if (workOut && [workOut compare:@"True"] == NSOrderedSame) {
                if(energy>19)
                {
                    [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"GubbeTranar.png"]];                   
                    energy-=20;
                    Str+=5;
                }
            }
            NSString *stopTalk = [properties valueForKey:@"stopTalk"];
            if (stopTalk && [stopTalk compare:@"True"] == NSOrderedSame) {
                [self hideBubbla];
            }
            NSString *sleep = [properties valueForKey:@"sleep"];
            if (sleep && [sleep compare:@"True"] == NSOrderedSame) {
                if(energy>50)
                {
                    Int-=5;
                }
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeSleeping.png"]];
                energy=100;
                days++;
                
            }
            NSString *notsleep = [properties valueForKey:@"notSleep"];
            if (notsleep && [notsleep compare:@"True"] == NSOrderedSame) {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbe.png"]];
            }
            NSString *world2 = [properties valueForKey:@"NewWorld"];
            if (world2 && [world2 compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"World2.tmx":@"SpawnPoint2"];
                return;
            }
            NSString *world1 = [properties valueForKey:@"World1"];
            if (world1 && [world1 compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"World1.tmx":@"SpawnPoint2"];
                return;
            }
            NSString *outhome = [properties valueForKey:@"OutHome"];
            if (outhome && [outhome compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"World2.tmx":@"SpawnPointHome"];
                return;
            }
            NSString *collision = [properties valueForKey:@"Collidable"];
            if (collision && [collision compare:@"True"] == NSOrderedSame) {
                return;
            }
        }
    }
    player.position = position;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CGPoint touchLocation = [touch locationInView: [touch view]];		
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    CGPoint playerPos = player.position;
    CGPoint diff = ccpSub(touchLocation, playerPos);
    if (abs(diff.x) > abs(diff.y)) {
        if (diff.x > 0) {
            jumpAble=0;
            playerPos.x += tileMap.tileSize.width;
            if(playerWalk==0)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeSidan.png"]];
                playerWalk++;
            }
            else if(playerWalk==1)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeSidan2.png"]];
                playerWalk=0;
            }
        } else {
            jumpAble=0;
            playerPos.x -= tileMap.tileSize.width;
            if(playerWalk==0)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeSidanLeft.png"]];
                playerWalk++;
            }
            else if(playerWalk==1)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeSidanLeft2.png"]];
                playerWalk=0;
            }
        }    
    } else {
        if (diff.y > 0) {
            jumpAble=0;
            playerPos.y += tileMap.tileSize.height;
            if(playerWalk==0)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeBak1.png"]];
                playerWalk++;
            }
            else if(playerWalk==1)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeBak2.png"]];
                playerWalk=0;
            }
        } else {
            jumpAble=1;
            playerPos.y -= tileMap.tileSize.height;
            if(playerWalk==0)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbe1.png"]];
                playerWalk++;
            }
            else if(playerWalk==1)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbe2.png"]];
                playerWalk=0;
            }
        }
    }
    
    if (playerPos.x <= (tileMap.mapSize.width * tileMap.tileSize.width) &&
        playerPos.y <= (tileMap.mapSize.height * tileMap.tileSize.height) &&
        playerPos.y >= 0 &&
        playerPos.x >= 0 ) 
    {
        [self setPlayerPosition:playerPos];
        
    }
    
    [self setViewpointCenter:player.position];
    
}


#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end