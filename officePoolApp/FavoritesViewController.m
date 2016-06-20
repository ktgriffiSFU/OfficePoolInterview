//
//  FavoritesViewController.m
//  officePoolApp
//
//  Created by Kyle Griffith on 2016-06-16.
//  Copyright © 2016 Kyle Griffith. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FavoritesViewController.h"
#import "WebViewController.h"
#import "FavoriteCell.h"
@interface  FavoritesViewController()<WebViewControllerDelegate>

@end

@implementation FavoritesViewController

{
    
}
@synthesize tableView,favoriteItems,favoriteIconData; // Add this line of code


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title= @"Favorites";
    

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    favoriteItems= [[[NSUserDefaults standardUserDefaults] objectForKey:@"favoritesArray"] mutableCopy];
    favoriteIconData = [self createIconData];
    
    [self.tableView reloadData];


}
-(NSMutableArray *)createIconData{
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    NSArray *extractedArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"favoritesData"];
    for (int i=0; i<[extractedArray count]; i++) {
        
        NSData *tempData=[extractedArray objectAtIndex:i];
        if (tempData!=nil) {
            [dataArray insertObject:tempData atIndex:i];
        }else{
            NSString *emptyString=[NSString stringWithFormat:@"EMPTY"];
            [dataArray insertObject:emptyString atIndex:i];

        }
    }
    return dataArray;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [favoriteItems count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FavoriteCell";
    
    FavoriteCell *cell = (FavoriteCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FavoriteCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSArray *favoritesDisplayed=[[favoriteItems reverseObjectEnumerator]allObjects];
    

    cell.accessoryType  = UITableViewCellStateDefaultMask;
    cell.itemLabel.text=[favoriteItems objectAtIndex:indexPath.row];
    NSString *searchString=[favoriteItems objectAtIndex:indexPath.row];
    if (![self hasSpaces:searchString]) {
        cell.favoritesIcon.image=[UIImage imageWithData:[favoriteIconData objectAtIndex:indexPath.row]];

    }else{
        cell.favoritesIcon.image=[UIImage imageNamed:@"wikiLogo"];

    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self passDataForward:[favoriteItems objectAtIndex:indexPath.row]];
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"willSelectRowAtIndexPath");
    return indexPath;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        [self.favoriteItems removeObjectAtIndex:indexPath.row];
        [self.favoriteIconData removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:favoriteItems forKey:@"favoritesArray"];
        [[NSUserDefaults standardUserDefaults] setObject:favoriteIconData forKey:@"favoritesData"];

        [self.tableView reloadData]; // tell table to refresh now
    }
}
- (void)passDataForward : (NSString*)favorite
{
    
    WebViewController *secondViewController =[[WebViewController alloc] init];
    secondViewController.delegate=self;
    secondViewController.searchString=favorite;
    [self.navigationController pushViewController:secondViewController animated:YES];
    
}
-(void)dataFromController:(bool)newData;
{
    newData=true;
}
-(bool)hasSpaces :(NSString*)foo{
    NSRange whiteSpaceRange = [foo rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location != NSNotFound) {
        return true;
    }else{
        return false;
    }
}

@end