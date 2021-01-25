//
//  GifDecompositionViewController.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#import "GifDecompositionViewController.h"
#import "GifCollectionViewCell.h"
#import "SDWebImage.h"

static const NSInteger kSearchHeight = 60;

@interface GifDecompositionViewController ()<UICollectionViewDataSource,
                                             UICollectionViewDelegate,
                                             UISearchBarDelegate>

@property (nonatomic, strong) NSArray<GifSearchItem*>* dataSourceItems;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *noItemsLabel;
@property (nonatomic, strong) UIView *searchBarContainer;

@end

@implementation GifDecompositionViewController

#pragma mark - Lifecycle
-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCollectionView];
    [self configureSearchBar];
    [self configureActivityIndicator];
    [self configureNoItemsUI];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.noItemsLabel.hidden = TRUE;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self configureKeyboardNotification];
    self.navigationItem.title = @"Test Task";
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
}

#pragma mark - UI Configureation
-(void)configureCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                                          collectionViewLayout:layout];
    
    collectionView.translatesAutoresizingMaskIntoConstraints = FALSE;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = UIColor.whiteColor;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, kSearchHeight, 0);
    collectionView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    [self.view addSubview:collectionView];
    
    [collectionView.topAnchor constraintEqualToAnchor: self.view.topAnchor].active = TRUE;
    [collectionView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor].active = TRUE;
    [collectionView.trailingAnchor constraintEqualToAnchor: self.view.trailingAnchor].active = TRUE;
    [collectionView.bottomAnchor constraintEqualToAnchor: self.view.bottomAnchor].active = TRUE;
    [collectionView registerClass:[GifCollectionViewCell class] forCellWithReuseIdentifier:@"GifCollectionViewCell"];
    
    self.collectionView = collectionView;
}

-(void)configureNoItemsUI {
    UILabel *label = [UILabel new];
    
    label.translatesAutoresizingMaskIntoConstraints = FALSE;
    label.text = @"No Items";
    [self.view addSubview: label];
    
    [label.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant: 40].active = TRUE;
    [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = TRUE;
    
    self.noItemsLabel = label;
}

-(void)configureActivityIndicator {
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    
    activityView.translatesAutoresizingMaskIntoConstraints = FALSE;
    activityView.hidesWhenStopped = TRUE;
    
    [self.view addSubview: activityView];
    
    [activityView.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant: 40].active = TRUE;
    [activityView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = TRUE;
    [activityView stopAnimating];
    
    self.activityView = activityView;
}

-(void)configureSearchBar {
    UIView *searchBarContainer = [UIView new];
    UISearchBar *searchBar = [UISearchBar new];
    
    [searchBarContainer addSubview: searchBar];
    [self.view addSubview:searchBarContainer];
    
    searchBarContainer.backgroundColor = UIColor.whiteColor;
    searchBarContainer.translatesAutoresizingMaskIntoConstraints = FALSE;
    
    searchBar.returnKeyType = UIReturnKeyDone;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.translatesAutoresizingMaskIntoConstraints = FALSE;
    searchBar.backgroundColor = UIColor.lightGrayColor;
    searchBar.tintColor = UIColor.blackColor;
    searchBar.placeholder = @"Search";
    searchBar.backgroundImage = [UIImage new];
    searchBar.translucent = FALSE;
    searchBar.enablesReturnKeyAutomatically = FALSE;
    searchBar.delegate = self;
    
    [searchBarContainer.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-kSearchHeight].active = TRUE;
    [searchBarContainer.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = TRUE;
    [searchBarContainer.leftAnchor constraintEqualToAnchor: self.view.leftAnchor].active = TRUE;
    [searchBarContainer.rightAnchor constraintEqualToAnchor: self.view.rightAnchor].active = TRUE;
    
    [searchBar.topAnchor constraintEqualToAnchor: searchBarContainer.topAnchor].active = TRUE;
    [searchBar.leftAnchor constraintEqualToAnchor: searchBarContainer.leftAnchor].active = TRUE;
    [searchBar.rightAnchor constraintEqualToAnchor: searchBarContainer.rightAnchor].active = TRUE;
    [searchBar.heightAnchor constraintEqualToConstant: kSearchHeight].active = TRUE;
    
    self.searchBarContainer = searchBarContainer;
}

#pragma mark - Keyboard Appearance
-(void)configureKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGFloat keyboardShift = self.view.safeAreaInsets.bottom - keyboardSize.height;
    CGFloat collectionBottomContentInset = fabs(keyboardShift) + kSearchHeight;
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:((UIViewAnimationOptions)animationCurve << 16)
                     animations:^{
        self.searchBarContainer.transform = CGAffineTransformMakeTranslation(0, keyboardShift);
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, collectionBottomContentInset, 0);
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, fabs(keyboardShift), 0);
    } completion: nil];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:((UIViewAnimationOptions)animationCurve << 16)
                     animations:^{
        self.searchBarContainer.transform = CGAffineTransformIdentity;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, kSearchHeight, 0);
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, kSearchHeight, 0);
    } completion: nil];
}

#pragma mark - GifDecompositionViewable
-(void)setIsLoaded {
    [self.activityView stopAnimating];
    
    self.collectionView.userInteractionEnabled = TRUE;
}

-(void)setIsLoadingProgress {
    [self.activityView startAnimating];
    
    self.collectionView.userInteractionEnabled = FALSE;
    self.noItemsLabel.hidden = TRUE;
}

-(void)showItems: (NSArray<GifSearchItem*>*) items {
    self.dataSourceItems = items;
    [self.collectionView reloadData];
    [self.collectionView setContentOffset: CGPointMake(0, -self.view.safeAreaInsets.top)];
    
    self.collectionView.hidden = FALSE;
    self.noItemsLabel.hidden = TRUE;
}

-(void)showNoItemsWith:(NSString *)search {
    self.collectionView.hidden = TRUE;
    self.noItemsLabel.hidden = FALSE;
    self.noItemsLabel.text = [NSString stringWithFormat:@"No items found for `%@`", search];
}

- (void)addNextItems:(NSArray<GifSearchItem *> *)items {
    self.dataSourceItems = [self.dataSourceItems arrayByAddingObjectsFromArray:items];
    [self.collectionView reloadData];
}

#pragma mark - UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.presenter setSearch: searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize estimatedSize = CGSizeMake(collectionView.bounds.size.width / 2, collectionView.bounds.size.width / 2);
    
    NSURL *url = self.dataSourceItems[indexPath.item].originalUrl;
    GifCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GifCollectionViewCell" forIndexPath:indexPath];
    
    [cell updateURL: url estimatedSize: estimatedSize];
    
    return cell;
}

#pragma mark - UICollectionViewLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width / 2, collectionView.bounds.size.width / 2);
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.contentInset.bottom) < 200) {
        [self.presenter loadNextPage];
    }
}

@end
