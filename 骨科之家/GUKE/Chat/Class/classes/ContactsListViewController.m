//
//  ContactsListViewController.m
//  VColleagueChat
//
//  Created by lqy on 4/26/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import "ContactsListViewController.h"
#import "ContactsListCell.h"
#import "UINavigationItem+selfArchItem.h"
#import "ContactsItem.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "VChatViewController.h"
@interface ContactsListViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    UITableView *_tableView;
    UISearchDisplayController *searchDispController;
    
    ASIFormDataRequest *contactList;
    
    NSMutableArray *selectIndexPaths;
}

@property (nonatomic,SSRCAutoIdRetainOrStrong) NSMutableArray *dataSoureArr;
@property (nonatomic,SSRCAutoIdRetainOrStrong) NSMutableArray *addGroupMenberArr;
@end

@implementation ContactsListViewController

- (void)dealloc{
    ASISafeRelease(contactList)
    SSRCRelease(searchDispController)
    SSRCSafeRelease(_addGroupMenberArr)
    SSRCSafeRelease(_dataSoureArr)
    SSRCRelease(_tableView)
    
    SSRCRelease(selectIndexPaths)
    SSRCSuperDealloc
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
//        self.dataSoureArr = [NSMutableArray array];
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObject:@"adhfj"];
        [tempArr addObject:@"zhang"];
        [tempArr addObject:@"苏沪"];
        [tempArr addObject:@"afhdsj"];
        [tempArr addObject:@"cdjh"];
        [tempArr addObject:@"zdha"];
        [tempArr addObject:@"哈哈哈"];
        [tempArr addObject:@"中玩儿"];
        [tempArr addObject:@"bhsd"];
        [tempArr addObject:@"afzhdsj"];
        [tempArr addObject:@"cd12jh"];
        [tempArr addObject:@"3zdha"];
        [tempArr addObject:@"d d 哈哈哈"];
        [tempArr addObject:@"qwe中玩儿"];
        [tempArr addObject:@"afhdsj"];
        [tempArr addObject:@"qwecdjh"];
        [tempArr addObject:@"qwezdha"];
        [tempArr addObject:@"哈哈哈"];
        [tempArr addObject:@"sd中玩儿"];
        
        NSMutableArray *ssArr = [NSMutableArray array];
        for (id obj in tempArr) {
            ContactsItem *item = [[ContactsItem alloc] init];
            item.fullName = obj;
            [ssArr addObject:item];
            SSRCRelease(item);
        }
//        self.dataSoureArr = [self partitionObjects:ssArr collationStringSelector:@selector(getItemIndexKeyForKeyName)];//
        
        selectIndexPaths = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutView];
    [self getContactLists];
}
#define serch_h 40.0f
- (void)returnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
// 页面的布局
- (void)layoutView{
    [self.navigationItem selfArchSetReturnAnimated:NO Sel:@selector(returnClick) target:self];
    [self.navigationItem selfArchSetTitle:@"添加参与人"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 70, 34);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setBackgroundImage:[UIImage imageNamed:@"button_bj.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:right animated:YES];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, serch_h, 320, SCREEN_HEIGHT-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = RGBA(110, 110, 110, .4);
    _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    if (IsIOS7) _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, serch_h)];
    searchBar.placeholder = @"搜索";
//    _tableView.tableHeaderView = searchBar;
    [self.view addSubview:searchBar];
    
    searchDispController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDispController.delegate = self;
    searchDispController.searchResultsDataSource = self;
    searchDispController.searchResultsDelegate = self;
    
    SSRCRelease(searchBar);
}

-(NSMutableArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector// 比较排序字符串的选择的方法
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    NSInteger sectionCount = [[collation sectionTitles] count]; //section count is take from sectionTitles and not sectionIndexTitles
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    //create an array to hold the data for each section
    for(int i = 0; i < sectionCount; i++)
    {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    //put each object into a section
    for (id object in array)
    {
        NSInteger index = [collation sectionForObject:object collationStringSelector:selector];
        [[unsortedSections objectAtIndex:index] addObject:object];
    }
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    //sort each section
    for (NSMutableArray *section in unsortedSections)
    {
        [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:selector]];
    }
    return sections;
}
#pragma mark search delegate

#pragma mark tableview delegate datasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        BOOL showSection = [[self.dataSoureArr objectAtIndex:section] count] != 0;
        //only show the section title if there are rows in the section
        return (showSection) ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }else if(tableView == searchDispController.searchResultsTableView){
        return nil;
    }
    return nil;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        NSMutableArray * existTitles = [NSMutableArray array];
        NSArray * allTitles = [[UILocalizedIndexedCollation currentCollation] sectionTitles];
        //section数组为空的title过滤掉，不显示
        for (int i=0; i<[allTitles count]; i++) {
            if ([[self.dataSoureArr objectAtIndex:i] count] > 0) {
                [existTitles addObject:[allTitles objectAtIndex:i]];
            }
        }
        return existTitles;
    }
    return nil;
}

//Determine the correct section to go to for a given index
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //sectionForSectionIndexTitleAtIndex: is a bit buggy, but is still useable
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[UILocalizedIndexedCollation currentCollation] sectionTitles].count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ContactsListCell heightForCell];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.dataSoureArr objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellInde = @"cellIndentcontactslistcell";
    ContactsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInde];
    if (!cell) {
        cell = SSRCReturnRetained([[ContactsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInde]);
    }
    if ([selectIndexPaths containsObject:indexPath]) {
        cell.sureSelect = YES;
    }else{
        cell.sureSelect = NO;
    }
    [cell fillViewWithObject:[[self.dataSoureArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactsListCell *cell = (ContactsListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([selectIndexPaths containsObject:indexPath]) {
        [selectIndexPaths removeObject:indexPath];
        cell.sureSelect = NO;
    }else{
        [selectIndexPaths addObject:indexPath];
        cell.sureSelect = YES;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*获取数据*/
#pragma mark ----- get data

- (void)getContactLists{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    ASISafeRelease(contactList);
    contactList = SSRCReturnRetained([HttpRequsetFactory getRequestKeys:nil subUrl:SUB_URL_USERLIST userCommon:YES]);
    [contactList setDelegate:self];
    [contactList setDidFailSelector:@selector(fail:)];
    [contactList setDidFinishSelector:@selector(finish:)];
    [contactList startAsynchronous];
}
- (void)fail:(ASIHTTPRequest *)request{
    
}
- (void)finish:(ASIHTTPRequest *)request{
    NSString *response = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
    SSRCAutorelease(response);
    NSDictionary *dic = [request.responseString objectFromJSONString ];
    if (request.responseStatusCode == 200 && [[NSString stringWithFormat:@"%@",[dic objectForKey:CKEY]]isEqualToString:SUC_CKEY]){
        NSArray *contactslistarr = [ContactsItem contactsItemMake:[dic objectForKey:@"userlist"]];
         self.dataSoureArr = [self partitionObjects:contactslistarr collationStringSelector:@selector(getItemIndexKeyForKeyName)];
        [_tableView reloadData];
    }
}
// 点击进入聊天的窗口
- (void)sureClick{
    if (selectIndexPaths.count == 1) {
        NSIndexPath *inde = [selectIndexPaths objectAtIndex:0];
        ContactsItem *item = [[self.dataSoureArr objectAtIndex:inde.section] objectAtIndex:inde.row];
        VChatViewController *vc = [[VChatViewController alloc] init];
        vc.recvId = [NSNumber numberWithInt:[item.userId intValue]];
        vc.recvName = item.username;
        vc.type = VChatType_pChat;
        [self.navigationController pushViewController:vc animated:YES];
        SSRCRelease(vc)
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
