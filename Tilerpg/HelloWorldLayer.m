// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "ShortestPath.h"
#pragma mark - HelloWorldLayer
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
    CGPoint viewPoint;
    CCMenu *menu;
    CGSize size;
    CCLabelTTF *pratLabel;
    CCSprite *pratBubbla;
    CCMenu * pratMenu;
    CCLabelTTF *Op1;
    CCLabelTTF *Op2;
    int PratID;
    ShortestPath *_shortestPath;
    int present;
    int flower;
    int jewlery;
    CGPoint targetPoint;
    CCLayer * layer;
    CCSprite * ruta;
    CCLabelTTF * statLabel;
    CCMenu * saveMenu;
    int bicycle;
    int BiBought;
    int AxeBought;
    int startLumber;
    int TrainTicket;
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
        Op1 = [CCLabelTTF labelWithString:@"Cool Story Bro yeahyeah" fontName:@"Helvetica-Bold" fontSize:25];
        Op2 = [CCLabelTTF labelWithString:@"Cool Story Bro yeahyeah" fontName:@"Helvetica-Bold" fontSize:25];
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
    money=200000;
    Int=0;
    Str=50;
    Cha=0;
    energy=1000;
    days=1;
    
    tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"World2.tmx"];
    background = [tileMap layerNamed:@"background"];
    foreground = [tileMap layerNamed:@"foreground"];
    meta = [tileMap layerNamed:@"Meta"];
    meta.visible=NO;
    [self addChild:tileMap z:-1];
    player = [CCSprite spriteWithFile:@"gubbe.png"];
    
    CCTMXObjectGroup *objects = [tileMap objectGroupNamed:@"Objects"];
    NSAssert(objects != nil, @"'Objects' object group not found");
    NSMutableDictionary *spawnPoint = [objects objectNamed:@"SpawnPointHome"];        
    NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
    int x = [[spawnPoint valueForKey:@"x"] intValue];
    int y = [[spawnPoint valueForKey:@"y"] intValue];
    
    player.position = ccp(x, y);
    [self addChild:player]; 
    
    [self setViewpointCenter:player.position];
    self.isTouchEnabled = YES;
    [self removeChild:menu cleanup:YES];
    ruta=[CCSprite spriteWithFile:@"statRuta.png"];
    CCMenuItem *item = [CCMenuItemImage itemWithNormalImage:@"saveGame.png" selectedImage:@"saveGamePress.png" target:self selector:@selector(saveGame)];
    saveMenu = [CCMenu menuWithItems:item, nil];
    statLabel=[CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(300, 300) hAlignment:CCTextAlignmentLeft lineBreakMode:CCLineBreakModeMiddleTruncation fontName:@"Helvetica-Bold" fontSize:25];
    statLabel.color=ccc3(0,0,0);
    [self addChild:ruta];
    [self addChild:statLabel];
    [self addChild:saveMenu];
    
    [ruta setScaleX: size.width/1024];
    [ruta setScaleY: size.height/768];
    [statLabel setScaleX: size.width/1024];
    [statLabel setScaleY: size.height/768];
    [saveMenu setScaleX: size.width/1024];
    [saveMenu setScaleY: size.height/768];
    saveMenu.position=ccp(-500,-500);
}

-(void)saveGame
{
    NSUserDefaults *hej;
    hej = [NSUserDefaults standardUserDefaults];
    [hej setInteger:Int forKey:@"savedInt"];
    [hej setInteger:Str forKey:@"savedStr"];
    [hej setInteger:Cha forKey:@"savedCha"];
    [hej setInteger:energy forKey:@"savedEnergy"];
    [hej setInteger:money forKey:@"savedMoney"];
    [hej setInteger:days forKey:@"savedDays"];
    [hej setInteger:bicycle forKey:@"savedBicycle"];
    [hej setInteger:raise forKey:@"savedRaise"];
    
    [hej synchronize];
}

-(void)loadGame:(id)sender{
    NSUserDefaults *hej = [NSUserDefaults standardUserDefaults];
    Int = [hej integerForKey:@"savedInt"];
    Str = [hej integerForKey:@"savedStr"];
    Cha = [hej integerForKey:@"savedCha"];
    energy = [hej integerForKey:@"savedEnergy"];
    money = [hej integerForKey:@"savedMoney"];
    days = [hej integerForKey:@"savedDays"];
    bicycle = [hej integerForKey:@"savedBicycle"];
    raise = [hej integerForKey:@"savedRaise"];
    
    tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"World2.tmx"];
    background = [tileMap layerNamed:@"background"];
    foreground = [tileMap layerNamed:@"foreground"];
    meta = [tileMap layerNamed:@"Meta"];
    meta.visible=NO;
    [self addChild:tileMap z:-1];
    player = [CCSprite spriteWithFile:@"gubbe.png"];
    
    CCTMXObjectGroup *objects = [tileMap objectGroupNamed:@"Objects"];
    NSAssert(objects != nil, @"'Objects' object group not found");
    NSMutableDictionary *spawnPoint = [objects objectNamed:@"SpawnPointHome"];        
    NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
    int x = [[spawnPoint valueForKey:@"x"] intValue];
    int y = [[spawnPoint valueForKey:@"y"] intValue];
    
    player.position = ccp(x, y);
    [self addChild:player]; 
    
    [self setViewpointCenter:player.position];
    self.isTouchEnabled = YES;
    [self removeChild:menu cleanup:YES];
    ruta=[CCSprite spriteWithFile:@"statRuta.png"];
    CCMenuItem *item = [CCMenuItemImage itemWithNormalImage:@"saveGame.png" selectedImage:@"saveGamePress.png" target:self selector:@selector(saveGame)];
    NSLog(@"hej%@", item);
    saveMenu = [CCMenu menuWithItems:item, nil];
    statLabel=[CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(300, 300) hAlignment:CCTextAlignmentLeft lineBreakMode:CCLineBreakModeMiddleTruncation fontName:@"Helvetica-Bold" fontSize:25];
    statLabel.color=ccc3(0,0,0);
    [self addChild:ruta];
    [self addChild:statLabel];
    [self addChild:saveMenu];
    
    [ruta setScaleX: size.width/1024];
    [ruta setScaleY: size.height/768];
    [statLabel setScaleX: size.width/1024];
    [statLabel setScaleY: size.height/768];
    [saveMenu setScaleX: size.width/1024];
    [saveMenu setScaleY: size.height/768];
    saveMenu.position=ccp(-500,-500);
}

-(void)showRuta:(CGPoint)point:(int)newEnergy:(int)newMoney:(int)newInt:(int)newStr:(int)newCha:(int)newDay
{
    NSString * statString = [NSString stringWithFormat:@"Energy:\t%i\nMoney:\t%i\nIntelligence:\t%i\nStrength:\t%i\nCharm:\t%i\nDay:\t%i",newEnergy,newMoney,newInt,newStr,newCha,newDay];
    [statLabel setString:statString];
    ruta.position=point;
    statLabel.position=point;
    saveMenu.position=point;
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
        if(Int>=100)
        {
            raise+=1;
            [self stringChanged:@"Now you're an assistant!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"You need 100 Intelligence for a raise" :@"" :@"" :-1];
        }
    }
    if(PratID==3)
    {
        if(Int>=175)
        {
            raise+=1;
            [self stringChanged:@"Now you're a junior copywriter!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"You need 175 Intelligence for a raise" :@"" :@"" :-1];
        }
    }
    if(PratID==4)
    {
        if(Int>=250)
        {
            raise+=1;
            [self stringChanged:@"Now you're a software engineer!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"You need 250 Intelligence for a raise" :@"" :@"" :-1];
        }
    }
    if(PratID==5)
    {
        if(Int>=400)
        {
            raise+=1;
            [self stringChanged:@"Now you're the product manager!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"You need 400 Intelligence for a raise" :@"" :@"" :-1];
        }
    }
    if(PratID==6)
    {
        if(Int>=700)
        {
            raise+=1;
            [self stringChanged:@"Now you're the vice president of the company!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"You need 700 Intelligence for a raise" :@"" :@"" :-1];
        }
    }
    if(PratID==7)
    {
        if(Int>=1000)
        {
            raise+=1;
            [self stringChanged:@"Now you're the president of the company!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"You need 1000 Intelligence for a raise" :@"" :@"" :-1];
        }
    }
    if(PratID==8)
    {
        [self stringChanged:@"You're already the president" :@"" :@"" :-1];
    }
    if(PratID==9)
    {
        if(money>=50&&energy>=25)
        {
            energy-=25;
            Int+=20;
            money-=50;
            [self stringChanged:@"Well done! Come back if you need more help." :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"It costs 50 to be tutored" :@"" :@"" :-1];
        }
    }
    if (PratID==10) {
        if (Cha>74) {
            raise+=1;
            [self stringChanged:@"Now you're a bartender!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"Sorry, you need 75 Charm to be a bartender" :@"" :@"" :-1];
        }

    }
    if (PratID==12) {
        if (Cha>49) {
            [self stringChanged:@"Okay, I guess you´re kinda charmin" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"NO! You´re soo not my type! Beat it! Come back when you´ve increased your charm."  :@"" :@"" :-1];
        }
    }
    if (PratID==14) {
        if (Cha>99) {
            [self stringChanged:@"Oh! I can´t wait to see what it is!" :@"" :@"" :-1];
        
    }
        else {
            [self stringChanged:@"If you want to get to know me better you should increase your charm (100)" :@"" :@"" :-1];
        }
             }
    if (PratID==11){
        if (money>=200) {
            money-=200;
            flower=1;
            [self stringChanged:@"Good choice!" :@"" :@"" :-1];
            
        }
        else {
            [self stringChanged:@"Sorry, you don´t have enough money. Flowers cost 200." :@"" :@"" :-1];
        }
    }
    if (PratID==17) {
        if (money>=1000) {
            money-=1000;
            bicycle=1;
            BiBought=1;
            [self stringChanged:@"Good choice!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"Sorry, you don´t have enough money. A bicycle costs 1000." :@"" :@"" :-1];
        }
    }
    if (PratID==18) {
        if (money>=1000) {
            money-=1000;
            AxeBought=1;
            [self stringChanged:@"Good choice!" :@"" :@"" :-1];
            
        }
        else {
            [self stringChanged:@"Sorry, you don´t have enough money. An Axe costs 1000." :@"" :@"" :-1];
        }
    }
    if (PratID==19){
        if(AxeBought==0)
        {
            [self stringChanged:@"You need to have an axe first!" :@"" :@"" :-1];
        }
        if(AxeBought==1)
        {
            startLumber=1;
            [self stringChanged:@"Well then, get to work!" :@"" :@"" :-1];
        }
    }
    if (PratID==20) {
        TrainTicket=1;
        money-=100000;
        [self stringChanged:@"Go into the house when you feel like leaving." :@"" :@"" :-1];
        
    }
             
}
-(void)Option2:(id)sender{
    if(PratID<=9||PratID==19)
    {
        [self hideBubbla];
    }
    if (PratID==14) {
        if (Cha>99) {
            [self stringChanged:@"Well that´s rude. I think you should go and come back when you´re in a better mood" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"If you want to get to know me better you should increase your charm (100)" :@"" :@"" :-1];       
        }
    
    }
    if (PratID==11) {
        if (money>=400) {
            money-=400;
            jewlery=1;
            [self stringChanged:@"Good choice!" :@"" :@"" :-1];
            
        }
        else {
            [self stringChanged:@"Sorry, you don´t have enough money. Jewlery costs 400." :@"" :@"" :-1];
        }

    }
    if (PratID==17) {
        if (money>=1000) {
            money-=1000;
            AxeBought=1;
            [self stringChanged:@"Good choice!" :@"" :@"" :-1];
        }
        else {
            [self stringChanged:@"Sorry, you don´t have enough money. An Axe costs 1000." :@"" :@"" :-1];
        }
    }
    if (PratID==19) {
        [self stringChanged:@"Well then, go do something else." :@"" :@"" :-1]; 
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
    [self showRuta:ccp(x+winSize.width/3,y+winSize.height/3-(40*winSize.height/768)):energy:money:Int:Str:Cha:days];
}

-(void) registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
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
                    money+=20;
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
            NSString *World3 = [properties valueForKey:@"World3"];
            if (World3 && [World3 compare:@"True"] == NSOrderedSame) {
                if (TrainTicket==1) {
                    [self unloadWorld];
                    [self loadWorld:@"World3.tmx" :@"SpawnPointW3"];
                    return;
                            }
            }
            NSString *TalkTrain = [properties valueForKey:@"TalkTrain"];
            if (TalkTrain && [TalkTrain compare:@"True"] == NSOrderedSame) {
                if (TrainTicket==1) {
                    [self showBubbla:ccp(x-winSize.width/4+(30*winSize.width/1024),y+winSize.height/4+(60*winSize.height/768))];
                    [self stringChanged:@"You have already bought a ticket. Go into the station.":@"":@"":21];

                } else {
                    
                [self showBubbla:ccp(x-winSize.width/4+(30*winSize.width/1024),y+winSize.height/4+(60*winSize.height/768))];
                [self stringChanged:@"Do you want to buy a ticket for the train? It will cost you 100000.":@"Yes":@"No":20];
                
            }
            }
            NSString *W2 =[properties valueForKey:@"W2"];
            if (W2 && [W2 compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"World2.tmx" :@"SpawnPointW2"];
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
            NSString *home2 = [properties valueForKey:@"home2"];
            if (home2 && [home2 compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"Home2.tmx" :@"SpawnPoint"];
                return;
            }
            NSString *OutHome2 = [properties valueForKey:@"OutHome2"];
            if (OutHome2 && [OutHome2 compare:@"True"] == NSOrderedSame) {
                [self unloadWorld];
                [self loadWorld:@"World3.tmx" :@"SpawnPointOutHome2"];
                return;
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
                if(energy>19&&money>=10)
                {
                    [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"GubbeDricker.png"]];                    
                    energy-=20;
                    Cha+=5;
                    money-=10;
                }
            }
            
            
            NSString *work = [properties valueForKey:@"Work"];
            if (work && [work compare:@"True"] == NSOrderedSame) {
                if(energy>=25)
                {
                    [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"GubbePluggar.png"]];                    
                    energy-=25;
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
                    if(raise==6)
                    {
                        money+=1000;
                    }
                    if(raise==7)
                    {
                        money+=2000;
                    }
                    if(raise==8)
                    {
                        money+=5000;
                    }
                }
            }
            NSString *work2 = [properties valueForKey:@"JobTalk"];
            if (work2 && [work2 compare:@"True"] == NSOrderedSame) {
                [self showBubbla:ccp(x-winSize.width/4+(30*winSize.width/1024),y+winSize.height/4+(60*winSize.height/768))];
                [self stringChanged:@"What do you want?":@"Ask for a raise":@"Nothing":raise];
            }
            

            
            NSString *study = [properties valueForKey:@"study"];
            if (study && [study compare:@"True"] == NSOrderedSame) {
                if(energy>19)
                {
                    [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"GubbePluggar.png"]];                    
                    energy-=20;
                    Int+=5;
                }
            }
            NSString *schoolTalk = [properties valueForKey:@"SchoolTalk"];
            if (schoolTalk && [schoolTalk compare:@"True"] == NSOrderedSame) {
                [self showBubbla:ccp(x-winSize.width/4+(30*winSize.width/1024),y+winSize.height/4+(60*winSize.height/768))];
                [self stringChanged:@"Welcome! You need tutoring?":@"Tutor me!":@"Naw i'm good":9];

            }
            NSString *barTalk = [properties valueForKey:@"BarTalk"];
            if (barTalk && [barTalk compare:@"True"] == NSOrderedSame) {
                [self showBubbla:ccp(x-winSize.width/4+(30*winSize.width/1024),y+winSize.height/4+(60*winSize.height/768))];
                [self stringChanged:@"You need a job?":@"Yeah!":@"No thanks":10];
            }
            NSString *workBar = [properties valueForKey:@"WorkBar"];
            if (workBar && [workBar compare:@"True"] == NSOrderedSame) {
                if(jumpAble!=0)
                {
                    if (Cha>24) {
                        if (energy>=25) {
                            energy-=25;
                            money+=Cha*2;
                            [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeBartender.png"]];  
                        }
                    }
                }
            }
            NSString *LumberWork = [properties valueForKey:@"Chop"];
            if (LumberWork && [LumberWork compare:@"True"] == NSOrderedSame) {
                if (energy>=25) {
                    if (AxeBought==1) {
                        if (startLumber==1) {
                            energy-=25;
                            money+= Str * 3;
                            Str+=5;
                            [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeJobbar.png"]]; 
                        }
                    } 
                }
            }
            NSString *lumber = [properties valueForKey:@"lumberjack"];
            if (lumber && [lumber compare:@"True"] == NSOrderedSame) {
                [self showBubbla:ccp(x-winSize.width/4+(30*winSize.width/1024),y+winSize.height/4+(60*winSize.height/768))];
                [self stringChanged:@"It's a tough job lumberjacking, but it can be rewarding":@"Work as lumberjack":@"Don't work as lumberjack":19];
            }
            NSString *girlTalk = [properties valueForKey:@"GirlTalk"];
            if (girlTalk && [girlTalk compare:@"True"] == NSOrderedSame) {
                [self showBubbla:ccp(x-winSize.width/4+(30*winSize.width/1024),y+winSize.height/4+(60*winSize.height/768))];
                [self stringChanged:@"Hi Boy!" :@"You wanna hang?" :@"" :12];
                if (Cha>74) {
                    present=0;
                    [self stringChanged:@"Hi again. If you want to get to know me better you should increase your charm (100), come back later!" :@"" :@"" :13];
                }
                if (Cha>99) {
                    present=1;
                    [self stringChanged:@"Hi! You know it´s my birthday soon. You gonna get me something?" :@"Ofcourse!" :@"I don´t know..." :14];
                     }
                if (flower==1) {
                    [self stringChanged:@"Flowers? I guess that´s kinda sweet of you. Thanks! (+20 Charm)" :@"" :@"" :15];
                    Cha+=20;
                    present=0;
                }
                if (jewlery==1) {
                    [self stringChanged:@"OMG! I love this jewlery! It´s the best present ever! (+40 Charm)" :@"" :@"" :16];
                    Cha+=40;
                    present=0;
                }
                }
                     
            NSString *shopTalk = [properties valueForKey:@"ShopTalk"];
            if (shopTalk && [shopTalk compare:@"True"] == NSOrderedSame) {
                [self showBubbla:ccp(x-winSize.width/4+(30*winSize.width/1024),y+winSize.height/4+(60*winSize.height/768))];
                [self stringChanged:@"What would you like?" :@"A bicycle!(1000)" :@"An Axe!(1000)" :17];
                if (BiBought==1) {
                    [self stringChanged:@"What would you like?" :@"An Axe!(1000)" :@"I don´t know..." :18];                }
                if (AxeBought==1) {
                    [self stringChanged:@"What would you like?" :@"" :@"I don´t know..." :18];             
                }
                if (present==1) {
                [self stringChanged:@"What would you like?":@"Flowers!(200)":@"Jewlery!(400)":11];
            }
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

-(void) walking
{
    CGPoint playerTilePos = [self tileCoordForPosition:player.position];
    CGPoint targetTilePos = [self tileCoordForPosition:targetPoint];
    if(CGPointEqualToPoint(playerTilePos,targetTilePos))
    {
        [self unschedule:@selector(walking)];
        return;
    }
    //NSLog(@"%f%f%f%f",player.position.x,player.position.y,targetPoint.x,targetPoint.y);
    CGPoint playerPos = player.position;
    CGPoint diff = ccpSub(targetPoint, playerPos);
    if (abs(diff.x) > abs(diff.y)) {
        if (diff.x > 0) {
            jumpAble=0;
            playerPos.x += tileMap.tileSize.width;
            if(playerWalk==0)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeSidan.png"]];
                playerWalk++;
                if (bicycle==1) {
                    [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeCyklarRight.png"]];
                }
            }
            else if(playerWalk==1)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeSidan2.png"]];
                playerWalk=0;
                if (bicycle==1) {
                    [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeCyklarRight2.png"]];
                }
            }
        } else {
            jumpAble=0;
            playerPos.x -= tileMap.tileSize.width;
            if(playerWalk==0)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeSidanLeft.png"]];
                playerWalk++;
                if (bicycle==1) {
                    [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeCyklarLeft.png"]];
                }
            }
            else if(playerWalk==1)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeSidanLeft2.png"]];
                playerWalk=0;
                if (bicycle==1) {
              
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeCyklarLeft2.png"]];
                }
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
                if (bicycle==1) {
                    [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeCyklarBak1.png"]];
                }
            }
            else if(playerWalk==1)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeBak2.png"]];
                playerWalk=0;
                if (bicycle==1) {
                    [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeCyklarBak2.png"]];
                }
            }
        } else {
            jumpAble=1;
            playerPos.y -= tileMap.tileSize.height;
            if(playerWalk==0)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbe1.png"]];
                playerWalk++;
                if (bicycle==1) {
                    [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeCyklarFram1.png"]];
                }
            }
            else if(playerWalk==1)
            {
                [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbe2.png"]];
                playerWalk=0;
                if (bicycle==1) {
                    [player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"gubbeCyklarFram2.png"]];
                }
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

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    targetPoint= [touch locationInView: [touch view]];		
    targetPoint = [[CCDirector sharedDirector] convertToGL: targetPoint];
    targetPoint = [self convertToNodeSpace:targetPoint];
    CGPoint playerPos = player.position;
    CGPoint diff = ccpSub(targetPoint, playerPos);
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
    if(bicycle==0)
    {
        [self schedule:@selector(walking) interval:0.2];
    }
    if(bicycle==1)
    {
        [self schedule:@selector(walking) interval:0.08];
    }
    return YES;
    
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self unschedule:@selector(walking)];
    targetPoint.x=0;
    targetPoint.y=0;
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