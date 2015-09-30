//
//  SearchViewController.m
//  CoSearch
//
//  Created by Fnoz on 15/9/11.
//  Copyright (c) 2015年 Fnoz. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"

#define SearchButtonHeight 45.0f

@interface SearchViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 20.0f, 60.0f, 44.0f)];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 60.0f, 44.0f)];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64.0f, self.view.frame.size.width, self.view.frame.size.height-64.0f-SearchButtonHeight)];
    [self.view addSubview:self.webView];
    
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:self.urlFormatStr,self.searchKey]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-SearchButtonHeight, self.view.frame.size.width-60.0f, SearchButtonHeight)];
    self.textField.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.textField.text = self.searchKey;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.delegate = self;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, self.textField.frame.size.height)];
    [self.view addSubview:self.textField];
    
    self.searchTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60.0f, self.view.frame.size.height-SearchButtonHeight, 60.0f, SearchButtonHeight)];
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    NSMutableArray *searchTypeArray = appDelegate.searchTypeArray;
    [self.searchTypeBtn setTitle:[searchTypeArray objectAtIndex:self.searchTypeIndex] forState:UIControlStateNormal];
    [self.searchTypeBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    self.searchTypeBtn.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(selectSearchType)];
    [self.searchTypeBtn addGestureRecognizer:longPressGesture];
    [self.view addSubview:self.searchTypeBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboadWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)backPage
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    else
    {
        [self closePage];
    }
}

- (void)closePage
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)search
{
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:self.urlFormatStr,self.textField.text]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)selectSearchType
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self search];
    [textField endEditing:YES];
    return YES;
}

-(void) keyboadWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat offY = (self.view.frame.size.height-keyboardSize.height)-self.textField.frame.size.height;//屏幕总高度-键盘高度-UITextField高度
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self.textField.frame;
    frame.origin.y = offY;
    self.textField.frame = frame;
    
    frame = self.searchTypeBtn.frame;
    frame.origin.y = offY;
    self.searchTypeBtn.frame = frame;
    
    [UIView commitAnimations];
 }

-(void)keyboardWillHide:(NSNotification *)note{
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:0.3];
    self.textField.frame = CGRectMake(self.textField.frame.origin.x, self.view.frame.size.height-SearchButtonHeight, self.textField.frame.size.width, self.textField.frame.size.height);
    self.searchTypeBtn.frame = CGRectMake(self.view.frame.size.width-60.0f, self.view.frame.size.height-SearchButtonHeight, 60.0f, SearchButtonHeight);
    [UIView commitAnimations];
}

@end
