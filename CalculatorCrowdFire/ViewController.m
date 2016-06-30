//
//  ViewController.m
//  CalculatorCrowdFire
//
//  Created by Sahil Chaddha on 14/06/16.
//  Copyright © 2016 SahilC. All rights reserved.
//

#import "ViewController.h"
#import "DigitsCollectionViewCell.h"
#import "math.h"
#import "ResultsView.h"
#import "Utils.h"
#define NUMBER_OF_ROWS 5


@interface ViewController ()
{
    NSArray *elementsArray;
    NSMutableArray *resultArray;
    BOOL isResultsShown;
    BOOL shouldAddDecimal;
    BOOL isErrorEnabled;
    ResultsView *resultsView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    elementsArray = [[NSArray alloc]initWithObjects:@"7",@"8",@"9",@"CE",@"CL",@"4",@"5",@"6",@"%",@"/",@"1",@"2",@"3",@"^",@"*",@"0",@".",@"-",@"+",@"=", nil];
    resultArray = [[NSMutableArray alloc]init];
    shouldAddDecimal = true;
    isResultsShown = false;
    isErrorEnabled = false;
    [self.colView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"Recieved Memory Warning");
}

#pragma mark - UICollectionView Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return elementsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DigitsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DigitsCell" forIndexPath:indexPath];
    cell.digitLbl.textColor = [UIColor whiteColor];
    cell.digitLbl.text = [elementsArray objectAtIndex:indexPath.row];
    if (indexPath.row == [elementsArray count]-1)
        cell.backgroundColor = [Utils colorWithHexString:@"f1c40f" withOpacity:1.0];
    else if([self isOperand:(int)indexPath.row])
        cell.backgroundColor = [Utils colorWithHexString:@"34495e" withOpacity:0.6];
    else if (indexPath.row == 3 || indexPath.row == 4)
        cell.backgroundColor = [Utils colorWithHexString:@"e74c3c" withOpacity:1.0];
    else
        cell.backgroundColor = [Utils colorWithHexString:@"2c3e50" withOpacity:0.8];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
     CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screeHeight = [UIScreen mainScreen].bounds.size.height-120;
    CGSize cellSize;
    
    int cellWidth = screenWidth/NUMBER_OF_ROWS;
    int cellHeight = screeHeight/NUMBER_OF_ROWS;
    
    if(indexPath.row == 15)
        cellSize= CGSizeMake((cellWidth)*2,cellHeight);
    else if (indexPath.row == [elementsArray count]-1)
        cellSize= CGSizeMake(screenWidth ,cellHeight);
    else
        cellSize= CGSizeMake(cellWidth, cellHeight);
    
    NSLog(@"%@ ",NSStringFromCGSize(cellSize));
    return cellSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self handleTextOnLabels:(int)indexPath.row];
}

#pragma mark - Orientation Change

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.colView reloadData];
    if(resultsView)
        [self closeResultsView];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.colView reloadData];
         if(resultsView)
             [self closeResultsView];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


#pragma mark - Text Labels
- (void)handleTextOnLabels:(int)index
{
    if(isErrorEnabled)
    {
        isErrorEnabled = false;
        [self.resultsLbl setText:@"0"];
    }
    if(index == 16 && !shouldAddDecimal)
        return;

    if(index == 4)
    {
        [self.resultsLbl setText:@"0"];
        return;
    }
    else if (index == 3)
    {
        [self removeLastChar];
        return;
    }
    
    if(index == [elementsArray count]-1)
    {
        if([self isLastCharOperand])
            {
                [self removeLastChar];
            }
        [self calculateResult];
        return;
    }
    
    if(isResultsShown)
    {
        isResultsShown = false;
        
        if([self isOperand:index])
        {
            [self.resultsLbl setText:[NSString stringWithFormat:@"%@%@",self.resultsLbl.text,[elementsArray objectAtIndex:index]]];
        }
        else
        {
            if([[elementsArray objectAtIndex:index] isEqualToString:@"."])
                [self.resultsLbl setText:@"0."];
            else
                [self.resultsLbl setText:[elementsArray objectAtIndex:index]];
        }
        
        return;
    }
    
    if([self isOperand:index] && [self isLastCharOperand])
    {
        return;
    }
    
  if([self.resultsLbl.text isEqualToString:@"0"])
        {
            if(index == 16 || [self isOperand:index])
            {
                if(index==16)
                    shouldAddDecimal = false;
                self.resultsLbl.text = [NSString stringWithFormat:@"%@%@",self.resultsLbl.text,[elementsArray objectAtIndex:index]];
            }
            else
            {
                [self.resultsLbl setText:[elementsArray objectAtIndex:index]];
            }
        }
    else
    {
        if(index == 16 && [self isLastCharOperand])
        {
            shouldAddDecimal = false;
            self.resultsLbl.text = [NSString stringWithFormat:@"%@0%@",self.resultsLbl.text,[elementsArray objectAtIndex:index]];
        }
        else
        {
            if(index == 16)
                shouldAddDecimal = false;
            if([self isOperand:index] && [self isLastCharDecimal])
                [self removeLastChar];
                
            self.resultsLbl.text = [NSString stringWithFormat:@"%@%@",self.resultsLbl.text,[elementsArray objectAtIndex:index]];
        }
    }
    
    if([self isLastCharOperand])
        shouldAddDecimal = true;
    
    
}

- (void)removeLastChar
{
    if(self.resultsLbl.text.length > 1)
        self.resultsLbl.text = [self.resultsLbl.text substringToIndex:self.resultsLbl.text.length-1];
    else
        self.resultsLbl.text = @"0";
}

- (BOOL)isOperand:(int)index
{
    return [@[@"*",@"/",@"+",@"-",@"^",@"%"] containsObject:[elementsArray objectAtIndex:index]];
}

- (BOOL)isLastCharOperand
{
    return [@[@"*",@"/",@"+",@"-",@"^",@"%"] containsObject:[self.resultsLbl.text substringFromIndex:self.resultsLbl.text.length-1]];
}
- (BOOL)isLastCharDecimal
{
    if([[self.resultsLbl.text substringFromIndex:self.resultsLbl.text.length-1] isEqualToString:@"."])
        return YES;
    return NO;
}

- (BOOL)isOperandInString:(NSString*)str
{
    return [@[@"*",@"/",@"+",@"-",@"^",@"%"] containsObject:str];
}

- (id)calculateString:(int)operator withInit:(NSString*)initString WithOperand:(NSString*)operand
{
    
    switch (operator) {
        case 0:
        {
            //^
            return [NSString stringWithFormat:@"%.2f",pow([initString floatValue],[operand floatValue])];
            break;
        }
        case 1:
        {
            //*
            return [NSString stringWithFormat:@"%.2f",[initString floatValue]*[operand floatValue]];
            break;
        }
        case 2:
        {
            //Divide
            if([operand floatValue] == 0)
                return [NSError errorWithDomain:@"Cannot Divide By Zero" code:0 userInfo:nil];
            return [NSString stringWithFormat:@"%.2f",[initString floatValue]/[operand floatValue]];
            break;
        }
        case 3:
        {
            //%
            if([initString intValue] == 0 || [operand intValue] == 0)
                return [NSError errorWithDomain:@"Cannot Mod With Zero" code:0 userInfo:nil];
            return [NSString stringWithFormat:@"%.2f",(float)((int)[initString intValue]%(int)[operand intValue])];
            
            break;
        }
        case 4:
        {
            //+
            return [NSString stringWithFormat:@"%.2f",[initString floatValue]+[operand floatValue]];
            break;
        }
        case 5:
        {
            //-
            return [NSString stringWithFormat:@"%.2f",[initString floatValue]-[operand floatValue]];
            break;
        }
        default:
            break;
    }
    return @"";
}


- (NSInteger)countOccurencesOfString:(NSString*)searchString {
    NSInteger strCount = self.resultsLbl.text.length - [[self.resultsLbl.text stringByReplacingOccurrencesOfString:searchString withString:@""] length];
    return strCount / [searchString length];
}

- (void)calculateResult
{
    isResultsShown = true;
    [resultArray removeAllObjects];
    NSLog(@"%@",self.resultsLbl.text);
    [resultArray addObject:self.resultsLbl.text];
    NSString *string = self.resultsLbl.text;
    NSArray *operatorsArray = [[NSArray alloc]initWithObjects:@"^",@"*",@"/",@"%",@"+",@"-", nil];
    
    NSString *initVar = @"";
    NSString *finalVar = @"";
    for(int i=0;i<operatorsArray.count;i++)
    {
        for(int j=0;j<[self countOccurencesOfString:[operatorsArray objectAtIndex:i]];j++)
        {
            initVar =@"";
            finalVar = @"";
            for(int k=0;k<string.length;k++)
            {

                if([[string substringWithRange:NSMakeRange(k,1)] isEqualToString:[operatorsArray objectAtIndex:i]])
                {
                    for(int l=k+1;l<string.length;l++)
                    {

                        if(![self isOperandInString:[string substringWithRange:NSMakeRange(l, 1)]])
                        {
                            finalVar = [NSString stringWithFormat:@"%@%@",finalVar,[string substringWithRange:NSMakeRange(l, 1)]];
                        }
                        else
                            break;
                    }
                    
                    for(int m=k-1;m>=0;m--)
                    {
                        if(![self isOperandInString:[string substringWithRange:NSMakeRange(m,1)]])
                        {
                            initVar = [NSString stringWithFormat:@"%@%@",[string substringWithRange:NSMakeRange(m, 1)],initVar];
                        }
                        else
                            break;
                    }
                    id result = [self calculateString:i withInit:initVar WithOperand:finalVar];
                    
                    if([result isKindOfClass:[NSString class]] && ([result isEqualToString:@"inf"] || [result isEqualToString:@"-inf"]))
                    {
                        result = [NSError errorWithDomain:@"Infinity" code:0 userInfo:nil];
                    }
                    if([result isKindOfClass:[NSError class]])
                    {
                        NSLog(@"Error %@",[(NSError*)result domain]);
                        self.resultsLbl.text = [NSString stringWithFormat:@"Error - %@",[(NSError*)result domain]];
                        isErrorEnabled = true;
                        [resultArray addObject:result];
                        [self showResultsView];
                        return;
                    }
                    else
                    {
                        [resultArray addObject:[string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@%@",initVar,[operatorsArray objectAtIndex:i],finalVar] withString:[NSString stringWithFormat:@" ( %@%@%@ ) ",initVar,[operatorsArray objectAtIndex:i],finalVar]]];
                        
                        [resultArray addObject:[string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@%@",initVar,[operatorsArray objectAtIndex:i],finalVar] withString:[NSString stringWithFormat:@" ( %@ ) ",result]]];

                        string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@%@",initVar,[operatorsArray objectAtIndex:i],finalVar] withString:result];
                    }
                    
                    NSLog(@"%@",string);
                }
            }
        }
    }
    self.resultsLbl.text = string;
    [self showResultsView];
}

- (void)showResultsView
{
    resultsView = [[ResultsView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    resultsView.alpha = 0;
    resultsView.delegate = self;
    [resultsView addGestures];
    resultsView.dataArray = [resultArray copy];
    [resultsView.tbView reloadData];
    [self.view.superview addSubview:resultsView];
    
    [UIView animateWithDuration:0.4 animations:^{
        resultsView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closeResultsView
{
    [resultsView removeGestures];
    [UIView animateWithDuration:0.4 animations:^{
        resultsView.alpha = 0;
    } completion:^(BOOL finished) {
        [resultsView removeFromSuperview];
    }];
}

@end
