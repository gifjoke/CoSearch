//
//  ViewController.m
//  CoSearch
//
//  Created by Fnoz on 15/9/10.
//  Copyright (c) 2015年 Fnoz. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "SearchTypeCollectionCell.h"
#import "SearchType.h"

static NSString *const kSearchTypeCollectionCellID = @"kSearchTypeCollectionCellID";
#define SearchFieldHeight 52.0f
#define StatusBarHeight 20.0f

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIButton *searchTypeBtn;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIView *webViewContainer;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *urlFormatStr;
@property (nonatomic, strong) SearchType *currentType;
@property (nonatomic, strong) UIView *webViewTopMaskView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0f green:240/255.0f blue:244/255.0f alpha:1];
    
    UIView *inputBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, StatusBarHeight+SearchFieldHeight)];
    inputBgView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    [self.view addSubview:inputBgView];
    
    UIView *inputAngBtnBgView = [[UIView alloc] initWithFrame:CGRectMake(10, StatusBarHeight+8, self.view.frame.size.width-20, SearchFieldHeight-16)];
    inputAngBtnBgView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    inputAngBtnBgView.layer.cornerRadius = 5.0f;
    [self.view addSubview:inputAngBtnBgView];
    
    self.searchTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, inputAngBtnBgView.frame.size.height, inputAngBtnBgView.frame.size.height)];
    self.searchTypeBtn.layer.cornerRadius = 5.0f;
    self.searchTypeBtn.clipsToBounds = YES;
    self.searchTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    self.searchTypeBtn.imageView.layer.cornerRadius = 5.0f;
    self.searchTypeBtn.imageView.clipsToBounds = YES;
    self.searchTypeBtn.imageView.layer.borderColor = [self.view.backgroundColor CGColor];
    self.searchTypeBtn.imageView.layer.borderWidth = 2;
    [inputAngBtnBgView addSubview:self.searchTypeBtn];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger defaultSearchTypeId = [[defaults valueForKey:kSearchTypeCollectionCellID] integerValue];
    [self.searchTypeBtn setImage:[UIImage imageNamed:[self getImageNameBySearchTypeId:defaultSearchTypeId]] forState:UIControlStateNormal];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(inputAngBtnBgView.frame.size.height, 0, inputAngBtnBgView.frame.size.width-2*inputAngBtnBgView.frame.size.height, inputAngBtnBgView.frame.size.height)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.placeholder = @"输入关键字，点击搜索引擎";
    self.textField.font = [UIFont systemFontOfSize:15.0f];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, self.textField.frame.size.height)];
    self.textField.returnKeyType = UIReturnKeySearch;
    [inputAngBtnBgView addSubview:self.textField];
    
    self.searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(inputAngBtnBgView.frame.size.width-40, 0, inputAngBtnBgView.frame.size.height, inputAngBtnBgView.frame.size.height)];
    self.searchBtn.layer.cornerRadius = 5.0f;
    [self.searchBtn setImage:[UIImage imageNamed:@"goToSearch"] forState:UIControlStateNormal];
    self.searchBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 12, 8, 4);
    [self.searchBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [inputAngBtnBgView addSubview:self.searchBtn];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, SearchFieldHeight+StatusBarHeight, self.view.frame.size.width-20, self.view.frame.size.height-SearchFieldHeight-StatusBarHeight) collectionViewLayout:flowLayout];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.collectionView registerClass:[SearchTypeCollectionCell class] forCellWithReuseIdentifier:kSearchTypeCollectionCellID];
    [self.view addSubview:self.collectionView];
    
    self.webViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-SearchFieldHeight-StatusBarHeight)];
    self.webViewContainer.clipsToBounds = YES;
    [self decorateWebViewContainer];
    [self.view addSubview:self.webViewContainer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    return ((appDelegate.searchTypeArray.count)/3+1)*3;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTypeCollectionCell *cell = (SearchTypeCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kSearchTypeCollectionCellID forIndexPath:indexPath];
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    if (indexPath.row+2>appDelegate.searchTypeArray.count) {
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    NSMutableArray *searchTypeArray = appDelegate.searchTypeArray;
    NSString *searchTypeText;
    UIImage *searchTypeImage;
    if (indexPath.row<searchTypeArray.count)
    {
        searchTypeText = ((SearchType *)[searchTypeArray objectAtIndex:indexPath.row]).searchTypeName;
        searchTypeImage = [UIImage imageNamed:((SearchType *)[searchTypeArray objectAtIndex:indexPath.row]).searchTypeImageName];
    }
    else if (indexPath.row == searchTypeArray.count)
    {
        searchTypeText = @"添加";
        searchTypeImage = [UIImage imageNamed:@"addSearchType"];
    }
    else
    {
        searchTypeText = @"";
    }
    cell.searchTypeLabel.text = searchTypeText;
    cell.searchTypeImageView.image = searchTypeImage;
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.frame.size.width/3.0f, self.collectionView.frame.size.width/3.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    if (indexPath.row<appDelegate.searchTypeArray.count)
    {
        NSMutableArray *searchTypeArray = appDelegate.searchTypeArray;
        self.currentType = (SearchType *)[searchTypeArray objectAtIndex:indexPath.row];
        [self search];
    }
    else if(indexPath.row == appDelegate.searchTypeArray.count)
    {
        //fnoztodo 添加引擎
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

#pragma mark UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
//    [self showLoadingView];
    self.webView.frame = CGRectMake(0, -self.currentType.offsetY, self.webViewContainer.frame.size.width, self.webViewContainer.frame.size.height-48+self.currentType.offsetY);
    self.webViewTopMaskView.frame = CGRectMake(0, 0, self.webView.frame.size.width, self.currentType.offsetY);
    [self.webView.scrollView addSubview:self.webViewTopMaskView];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    if (self.webView.canGoBack) {
//        self.closeBtn.hidden = NO;
//    }
//    else
//    {
//        self.closeBtn.hidden = YES;
//    }
//    [self hideLoadingView];
}


#pragma mark Common
- (NSString *)getImageNameBySearchTypeId:(NSInteger)searchTypeId
{
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    for (SearchType *searchType in appDelegate.searchTypeArray) {
        if (searchType.searchTypeId == searchTypeId) {
            return searchType.searchTypeImageName;
        }
    }
    return nil;
}

- (void)decorateWebViewContainer
{
    self.webViewContainer.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.webViewContainer.frame.size.width, self.webViewContainer.frame.size.height-48)];
    self.webView.delegate = self;
    self.webView.backgroundColor = self.webViewContainer.backgroundColor;
    [self.webViewContainer addSubview:self.webView];
    
    self.webViewTopMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.webView.frame.size.width, 0)];
    self.webViewTopMaskView.backgroundColor = self.webViewContainer.backgroundColor;
    [self.webView.scrollView addSubview:self.webViewTopMaskView];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, self.webView.frame.size.height, self.webViewContainer.frame.size.width, 1.0f);
    topBorder.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    [self.webViewContainer.layer addSublayer:topBorder];
    
    UIButton *backPage = [[UIButton alloc] initWithFrame:CGRectMake(0, self.webView.frame.size.height+1, self.view.frame.size.width/5.0, 47)];
    [backPage setImage:[UIImage imageNamed:@"backPage"] forState:UIControlStateNormal];
    backPage.imageEdgeInsets = UIEdgeInsetsMake(10, 10+0.5*(backPage.frame.size.width-47), 10, 10+0.5*(backPage.frame.size.width-47));
    [backPage addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
    [self.webViewContainer addSubview:backPage];
    
    UIButton *reloadPage = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/5.0, self.webView.frame.size.height+1, self.view.frame.size.width/5.0, 47)];
    [reloadPage setImage:[UIImage imageNamed:@"reloadPage"] forState:UIControlStateNormal];
    reloadPage.imageEdgeInsets = UIEdgeInsetsMake(10, 10+0.5*(backPage.frame.size.width-47), 10, 10+0.5*(backPage.frame.size.width-47));
    [reloadPage addTarget:self action:@selector(reloadPage) forControlEvents:UIControlEventTouchUpInside];
    [self.webViewContainer addSubview:reloadPage];
    
    UIButton *closeWebView = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/5.0*2, self.webView.frame.size.height+1, self.view.frame.size.width/5.0, 47)];
    [closeWebView setImage:[UIImage imageNamed:@"home"] forState:UIControlStateNormal];
    closeWebView.imageEdgeInsets = UIEdgeInsetsMake(10, 10+0.5*(backPage.frame.size.width-47), 10, 10+0.5*(backPage.frame.size.width-47));
    [closeWebView addTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.webViewContainer addSubview:closeWebView];
    
    UIButton *copyUrl = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/5.0*3, self.webView.frame.size.height+1, self.view.frame.size.width/5.0, 47)];
    [copyUrl setImage:[UIImage imageNamed:@"copyUrl"] forState:UIControlStateNormal];
    copyUrl.imageEdgeInsets = UIEdgeInsetsMake(10, 10+0.5*(backPage.frame.size.width-47), 10, 10+0.5*(backPage.frame.size.width-47));
    [copyUrl addTarget:self action:@selector(copyUrl) forControlEvents:UIControlEventTouchUpInside];
    [self.webViewContainer addSubview:copyUrl];
    
    UIButton *openInSafari = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/5.0*4, self.webView.frame.size.height+1, self.view.frame.size.width/5.0, 47)];
    [openInSafari setImage:[UIImage imageNamed:@"openInSafari"] forState:UIControlStateNormal];
    openInSafari.imageEdgeInsets = UIEdgeInsetsMake(10, 10+0.5*(backPage.frame.size.width-47), 10, 10+0.5*(backPage.frame.size.width-47));
    [openInSafari addTarget:self action:@selector(openInSafari) forControlEvents:UIControlEventTouchUpInside];
    [self.webViewContainer addSubview:openInSafari];
}

- (void)backPage
{
    
}

- (void)reloadPage
{
    
}

- (void)closeWebView
{
    [self showWebViewContainer:NO];
}

- (void)copyUrl
{
    
}

- (void)openInSafari
{
    
}

- (void)search
{
    NSString *searchKeyString = [self.textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:self.currentType.searchTypeModel, searchKeyString]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self showWebViewContainer:YES];
}

- (void)showWebViewContainer:(BOOL)isShow
{
    CGFloat oriY = isShow?SearchFieldHeight+StatusBarHeight:self.view.frame.size.height;
    if (isShow) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect frame = self.webViewContainer.frame;
            frame.origin.y = oriY;
            self.webViewContainer.frame = frame;
        } completion:^(BOOL finished) {
            ;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frame = self.webViewContainer.frame;
            frame.origin.y = oriY;
            self.webViewContainer.frame = frame;
        } completion:^(BOOL finished) {
            ;
        }];
    }
}

@end
