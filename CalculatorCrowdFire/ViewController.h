//
//  ViewController.h
//  CalculatorCrowdFire
//
//  Created by Sahil Chaddha on 14/06/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *colView;
@property (strong, nonatomic) IBOutlet UILabel *resultsLbl;


@end

