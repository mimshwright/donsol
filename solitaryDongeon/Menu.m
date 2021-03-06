//
//  Menu.m
//  solitaryDongeon
//
//  Created by Devine Lu Linvega on 2015-03-12.
//  Copyright (c) 2015 Devine Lu Linvega. All rights reserved.
//

#import "Menu.h"
#import "ViewController.h"
#import "User.h"
#import "Splash.h"

@implementation Menu

-(void)viewDidLoad
{
    [slideTimer invalidate];
    [self start];
}

-(void)start
{
    [self templateStart];
    [self template];
    [self generateCastle];
    [self template];
}

typedef NS_ENUM(NSInteger, CastleTile) {
    CastleBlank,
    CastlePeak,
    CastleTower,
    CastleBridge,
    CastleFort,
    CastleJoint,
    CastleFill,
    CastleDoor,
    CastleGrass,
    CastleFill1,
    CastleFill2,
    CastleStar
};

-(void)generateCastle
{
    NSLog(@"Generate Castle");

    int verticalTilesCount = 9;
    float matrix[8][verticalTilesCount];
    int towersLength = 3;

    // Create Blank

    for (int x=0; x<8; x++)
    {
        for (int y=0; y<verticalTilesCount; y++)
        {
            matrix[x][y] = CastleBlank;
        }
    }

    // Create Peaks(1)

    for (int x=0; x<8; x++)
    {
        for (int y=0; y<towersLength; y++)
        {
            if( arc4random() % 5 == 0 ){
                matrix[x][y] = CastlePeak;
            }

        }
    }

    // Create Towers(2)

    for (int y=0; y<towersLength; y++)
    {
        for (int x=0; x<verticalTilesCount; x++)
        {
            if( (int)matrix[x][y] == CastlePeak ){

                matrix[x][y+1] = CastleTower;
                if( arc4random() % 3 == 0 ){
                    matrix[x][y+2] = CastleTower;
                }
                if( arc4random() % 4 == 0 ){
                    matrix[x][y+3] = CastleTower;
                }
            }
        }
    }

    // Create bridges(3)

    for (int y=0; y<verticalTilesCount; y++)
    {
        for (int x=0; x<8; x++)
        {
            if( matrix[x][y-1] == CastleTower && matrix[x][y] == CastleBlank ){
                matrix[x][y] = CastleBridge;
                if( x < 7){
                    matrix[x+1][y] = CastleBridge;
                }
                if( x > 0){
                    matrix[x-1][y] = CastleBridge;
                }
            }
        }
    }

    // Create fort(4)

    for (int y=0; y<verticalTilesCount; y++)
    {
        for (int x=0; x<8; x++)
        {
            if( (matrix[x][y-1] == CastleBridge && matrix[x][y] == CastleBlank) || (matrix[x][y-1] == CastleBridge && matrix[x][y] == CastleFort) ){
                matrix[x][y] = CastleBridge;
                if( x < 7){
                    matrix[x+1][y] = CastleFort;
                }
                if( x > 0){
                    matrix[x-1][y] = CastleFort;
                }
            }
        }
    }

    // Create joints-between fort and tower(5)

    for (int y=0; y<verticalTilesCount; y++)
    {
        for (int x=0; x<8; x++)
        {
            if( matrix[x][y-1] == CastleTower && matrix[x][y+1] == CastleFort ){
                matrix[x][y] = CastleJoint;
            }
        }
    }

    // Create fills(6)

    for (int y=0; y<verticalTilesCount; y++)
    {
        for (int x=0; x<8; x++)
        {
            if( matrix[x][y-1] > CastleBlank && matrix[x][y] == CastleBlank && y > 0 ){
                matrix[x][y] = CastleFort;
            }
        }
    }

    // Correct towers(2)

    for (int y=0; y<verticalTilesCount; y++)
    {
        for (int x=0; x<8; x++)
        {
            if( matrix[x][y-1] == CastleTower && matrix[x][y+1] == CastleTower && matrix[x][y] == CastlePeak ){
                matrix[x][y] = CastleTower;
            }
        }
    }

    // Correct forts(3)

    for (int y=0; y<verticalTilesCount; y++)
    {
        for (int x=0; x<8; x++)
        {
            if( matrix[x][y-1] == CastleBlank && matrix[x][y] == CastleFort ){
                matrix[x][y] = CastleBridge;
            }
        }
    }

    // Correct joints(5)

    for (int y=0; y<verticalTilesCount; y++)
    {
        for (int x=0; x<8; x++)
        {
            if( matrix[x][y-1] == CastleTower && matrix[x][y] == CastleBridge ){
                matrix[x][y] = CastleJoint;
            }
            if( matrix[x][y-1] == CastlePeak && matrix[x][y] == CastleBridge ){
                matrix[x][y] = CastleJoint;
            }
        }
    }

    // Add doors(7)

    for (int y=0; y<verticalTilesCount; y++)
    {
        for (int x=0; x<8; x++)
        {
            if( matrix[x][y] == CastlePeak ){
                if(arc4random() % 4 == 0){
                    matrix[x][verticalTilesCount-1] = CastleDoor;
                }
            }
        }
    }

    // Correct filling(5)

    for (int y=0; y<verticalTilesCount; y++)
    {
        for (int x=0; x<8; x++)
        {
            if( matrix[x][y-1] == CastleBridge && matrix[x][y] == CastleBridge ){
                matrix[x][y] = CastleFort;
            }
            if( matrix[x][y-1] > CastleBlank && matrix[x][y] == CastleBridge ){
                matrix[x][y] = CastleFort;
            }
        }
    }

    // Add windows(6)

    for (int y=0; y<verticalTilesCount; y++)
    {
        for (int x=0; x<8; x++)
        {
            if( matrix[x][y-1] == CastleFort && matrix[x][y+1] == CastleFort && matrix[x-1][y] == CastleFort && matrix[x+1][y] == CastleFort ){
                if( matrix[x-1][y-1] == CastleFort && matrix[x+1][y+1] == CastleFort && matrix[x-1][y+1] == CastleFort && matrix[x+1][y-1] == CastleFort ){
                    matrix[x][y] = CastleFill;
                }
            }
        }
    }

    // Add grass(8)

    for (int x=0; x<8; x++)
    {
        if( matrix[x][verticalTilesCount-1] == CastleBlank ){
            matrix[x][verticalTilesCount-1] = CastleGrass;
        }
    }

    // Add different fils(9)

    for (int y=0; y<verticalTilesCount; y++)
    {
        for (int x=0; x<8; x++)
        {
            if( matrix[x][y] == CastleFort && arc4random() % 3 == 0 ){
                matrix[x][y] = CastleFill1;
            }
            if( matrix[x][y] == CastleFort && arc4random() % 13 == 0 ){
                matrix[x][y] = CastleFill2;
            }
        }
    }

    // Add stars

    for (int y=0; y<verticalTilesCount; y++)
    {
        for (int x=0; x<8; x++)
        {
            if( matrix[x][y-1] == CastleBlank && matrix[x][y+1] == CastleBlank && matrix[x-1][y] == CastleBlank && matrix[x+1][y] == CastleBlank ){
                if( matrix[x-1][y-1] == CastleBlank && matrix[x+1][y+1] == CastleBlank && matrix[x-1][y+1] == CastleBlank && matrix[x+1][y-1] == CastleBlank ){
                    if (arc4random() % 4 == 0 ) {
                        matrix[x][y] = CastleStar;
                    }

                }
            }
        }
    }

    // Empty View

    NSArray *viewsToRemove = [self.castleView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }

    // Print

    CGFloat margin = self.view.frame.size.width/16;
    CGFloat tileSize = (self.view.frame.size.width - (2*margin))/8;

    self.castleView.frame = CGRectMake(0, 0, self.view.frame.size.width, tileSize * verticalTilesCount + margin);
    self.castleView.backgroundColor = [UIColor clearColor];

    for (int x=0; x<8; x++)
    {
        for (int y=0; y<verticalTilesCount; y++)
        {
            NSLog(@"x:%d y:%d - > %d", x,y,(int)matrix[x][y] );

            UIImageView * castleTile = [[UIImageView alloc] initWithFrame:CGRectMake(margin + (tileSize*x), margin + (tileSize*y), tileSize, tileSize)];

            castleTile.backgroundColor = [UIColor blackColor];

            switch ((int)matrix[x][y]) {
                case CastlePeak:
                    castleTile.image = [UIImage imageNamed:@"piece.tower"];
                    break;
                case CastleTower:
                    castleTile.image = [UIImage imageNamed:@"piece.vertical"];
                    break;
                case CastleBridge:
                    castleTile.image = [UIImage imageNamed:@"piece.edge"];
                    break;
                case CastleFort:
                    castleTile.image = [UIImage imageNamed:@"piece.fill.1"];
                    break;
                case CastleJoint:
                    castleTile.image = [UIImage imageNamed:@"piece.junction"];
                    break;
                case CastleFill:
                    castleTile.image = [UIImage imageNamed:@"piece.window"];
                    break;
                case CastleDoor:
                    castleTile.image = [UIImage imageNamed:@"piece.door"];
                    break;
                case CastleGrass:
                    castleTile.image = [UIImage imageNamed:@"piece.grass"];
                    break;
                case CastleFill1:
                    castleTile.image = [UIImage imageNamed:@"piece.fill.2"];
                    break;
                case CastleFill2:
                    castleTile.image = [UIImage imageNamed:@"piece.fill.3"];
                    break;
                case CastleStar:
                    castleTile.image = [UIImage imageNamed:@"piece.star"];
                    break;
                default:
                    break;
            }

            [self.castleView addSubview:castleTile];
        }
    }


}

-(void)templateStart
{
    margin = self.view.frame.size.width/16;
}

-(void)template
{
    _enterButton.frame = CGRectMake(margin, self.castleView.frame.size.height + margin, self.view.frame.size.width-(2*margin), margin);

    _scoreLabel.frame = CGRectMake(margin, self.castleView.frame.size.height + margin, self.view.frame.size.width-(2*margin), margin);
    _scoreLabel.text = [NSString stringWithFormat:@"BEST SCORE %d",[user loadHighScore]];
    _scoreLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];

    _thanksLabel.frame = CGRectMake(margin, self.view.frame.size.height-(3*margin), self.view.frame.size.width-(2*margin), margin*2);
    _thanksLabel.text = @"SPECIAL THANKS\nJOHN ETERNAL, ZACH GAGE, KURT BIEG";
    _thanksLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
