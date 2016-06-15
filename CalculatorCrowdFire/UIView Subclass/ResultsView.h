//
//  ResultsView.h
//  CalculatorCrowdFire
//
//  Created by Sahil Chaddha on 15/06/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResultsViewDelegate <NSObject>
- (void)closeResultsView;
@end


@interface ResultsView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    id <ResultsViewDelegate> _delegate;
}
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) IBOutlet UITableView *tbView;
@property (strong, nonatomic) IBOutlet UIView *blurView;
@property (strong, nonatomic) IBOutlet UIView *gestureView;
@property (strong, nonatomic) IBOutlet UIView *closeBtn;
- (IBAction)closeBtnClicked:(id)sender;
- (void)addGestures;
- (void)removeGestures;
@end
