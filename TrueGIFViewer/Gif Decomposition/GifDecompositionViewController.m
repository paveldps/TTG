//
//  GifDecompositionViewController.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#import "GifDecompositionViewController.h"
#import "GifCollectionViewCell.h"
#import "SDWebImage.h"

@interface GifDecompositionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) NSArray<NSURL*>* urlItems;
@end

@implementation GifDecompositionViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    [self configureCollectionView];
    [self configureView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self configureKeyboardNotification];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
}

-(void)configureKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSNumber *duration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];

    [UIView animateWithDuration:duration.doubleValue animations:^{
        
        CGFloat keyboardShift = self.view.safeAreaInsets.bottom - keyboardSize.height;
        CGFloat collectionBottomContentInset = fabs(keyboardShift) + self.searchField.bounds.size.height + 24;
        
        self.searchField.transform = CGAffineTransformMakeTranslation(0, keyboardShift);
        
        self.collectionView.contentInset = UIEdgeInsetsMake(12, 0, collectionBottomContentInset, 0);
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, fabs(keyboardShift), 0);
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    NSNumber *duration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        self.searchField.transform = CGAffineTransformIdentity;
        
        self.collectionView.contentInset = UIEdgeInsetsMake(12, 0, 12, 0);
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}


-(void)configureCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                                          collectionViewLayout:layout];
    
    collectionView.translatesAutoresizingMaskIntoConstraints = FALSE;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = UIColor.orangeColor;
    collectionView.contentInset = UIEdgeInsetsMake(12, 0, 12, 0);
    collectionView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [collectionView registerClass:[GifCollectionViewCell class] forCellWithReuseIdentifier:@"GifCollectionViewCell"];
    
    [self.view addSubview:collectionView];
    
    [collectionView.topAnchor constraintEqualToAnchor: self.view.topAnchor].active = TRUE;
    [collectionView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor].active = TRUE;
    [collectionView.trailingAnchor constraintEqualToAnchor: self.view.trailingAnchor].active = TRUE;
    [collectionView.bottomAnchor constraintEqualToAnchor: self.view.bottomAnchor].active = TRUE;
    
    self.collectionView = collectionView;
}

-(void)configureView {
    UITextField *searchField = [[UITextField alloc] init];
    
    [self.view addSubview: searchField];
    
    [searchField setTextAlignment: NSTextAlignmentCenter];
    [searchField setReturnKeyType: UIReturnKeyDone];
    [searchField setAutocorrectionType: UITextAutocorrectionTypeNo];
    [searchField setTranslatesAutoresizingMaskIntoConstraints: FALSE];
    [searchField setBackgroundColor:UIColor.lightGrayColor];
    
    [searchField.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant: -12].active = TRUE;
    [searchField.heightAnchor constraintEqualToConstant: 60].active = TRUE;
    
    [searchField.leftAnchor constraintEqualToAnchor: self.view.leftAnchor constant: 20].active = TRUE;
    [searchField.rightAnchor constraintEqualToAnchor: self.view.rightAnchor constant: -20].active = TRUE;
    
    searchField.delegate = self;
    
    self.searchField = searchField;
}

-(void)markedTest {
    [self.presenter setSearch: self.searchField.text];
    
    [self.view endEditing: TRUE];
}

-(void)setIsLoaded {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.backgroundColor = UIColor.greenColor;
    });
}

-(void)setIsLoadingProgress {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.backgroundColor = UIColor.redColor;
    });
}

-(void)setItems: (NSArray<NSURL*>*) items {
    
    self.urlItems = items;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* search = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    [self.presenter setSearch: search];
    
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return TRUE;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.urlItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize estimatedSize = CGSizeMake(collectionView.bounds.size.width / 2, collectionView.bounds.size.width / 2);
    
    GifCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GifCollectionViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = UIColor.magentaColor;
    
    NSURL *url = self.urlItems[indexPath.item];
    
    [cell updateURL: url estimatedSize: estimatedSize];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width / 2, collectionView.bounds.size.width / 2);
}

@end
