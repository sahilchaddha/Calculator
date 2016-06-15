//
//  ResultsView.m
//  CalculatorCrowdFire
//
//  Created by Sahil Chaddha on 15/06/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import "ResultsView.h"
#import "ResultsTableViewCell.h"
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)


@implementation ResultsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UINib *nib = [UINib nibWithNibName:@"ResultsView" bundle:nil];
        self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        [self setFrame:frame];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        UINib *nib = [UINib nibWithNibName:@"ResultsView" bundle:nil];
        self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)addGestures
{
    if(SYSTEM_VERSION_GREATER_THAN(@"8"))
    {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        effectView.frame = [UIScreen mainScreen].bounds;
        [self.blurView addSubview:effectView];
    }
    else
    {
        self.blurView.backgroundColor = [UIColor whiteColor];
        self.blurView.alpha = 0.7;
    }
    
    UITapGestureRecognizer *gc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    [_gestureView addGestureRecognizer:gc];
    [self initSetup];
}

- (void)initSetup
{
    self.closeBtn.layer.masksToBounds = YES;
    self.closeBtn.layer.cornerRadius = self.closeBtn.frame.size.height/2;
    self.closeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.closeBtn.layer.borderWidth = 1.5f;
    
    [self.tbView registerNib:[UINib nibWithNibName:@"ResultsTableViewCell" bundle:nil] forCellReuseIdentifier:[NSString stringWithFormat:@"resultsCell"]];
    self.tbView.rowHeight = UITableViewAutomaticDimension;
    self.tbView.estimatedRowHeight = 50;
}
- (void)removeGestures
{
    for(UITapGestureRecognizer* gc in _gestureView.gestureRecognizers)
    {
        [_gestureView removeGestureRecognizer:gc];
    }
}
- (void)closeView:(UITapGestureRecognizer*)gc
{
    [_delegate closeResultsView];
}

- (IBAction)closeBtnClicked:(id)sender
{
    [_delegate closeResultsView];
}

#pragma mark - UITableView Delegate DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell"];
    if(!cell)
        cell = [[ResultsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"resultsCell"];
    
    if([[self.dataArray objectAtIndex:indexPath.row] isKindOfClass:[NSError class]])
    {
        cell.textLbl.text = [NSString stringWithFormat:@"%d. => %@",(int)indexPath.row+1,[(NSError*)[self.dataArray objectAtIndex:indexPath.row] domain]];
        cell.textLbl.textColor = [UIColor redColor];
    }
    else
    {
        cell.textLbl.text = [NSString stringWithFormat:@"%d. => %@",(int)indexPath.row+1,[self.dataArray objectAtIndex:indexPath.row]];
        cell.textLbl.textColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [_delegate closeResultsView];
}
@end
