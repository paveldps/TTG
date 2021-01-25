//
//  GifDecompositionViewController.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#import "GifDecompositionViewController.h"
#import "GifCollectionViewCell.h"
#import "SDWebImage.h"

@interface GifDecompositionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *searchBarContainer;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) NSArray<GifSearchItem*>* dataSourceItems;
@property (nonatomic, strong) UILabel *noItemsLabel;
@end

@implementation GifDecompositionViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCollectionView];
    [self configureSearchBar];
    [self configureActivityIndicator];
    [self configureNoItemsUI];
    
    [self.view setBackgroundColor:UIColor.whiteColor];
    [self.noItemsLabel setHidden: TRUE];
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
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGFloat keyboardShift = self.view.safeAreaInsets.bottom - keyboardSize.height;
    CGFloat collectionBottomContentInset = fabs(keyboardShift) + 60;
    
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
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 60, 0);
    } completion: nil];
}

-(void)configureNoItemsUI {
    UILabel *label = [UILabel new];
    
    [label setTranslatesAutoresizingMaskIntoConstraints: FALSE];
    
    [self.view addSubview: label];
    
    [label.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant: 40].active = TRUE;
    [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = TRUE;
    [label setText: @"No Items"];
    
    self.noItemsLabel = label;
}

-(void)configureActivityIndicator {
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    
    [activityView setTranslatesAutoresizingMaskIntoConstraints: FALSE];
    [activityView setHidesWhenStopped: TRUE];
    [activityView stopAnimating];
    
    [self.view addSubview: activityView];
    
    [activityView.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant: 40].active = TRUE;
    [activityView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = TRUE;
    
    self.activityView = activityView;
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
    collectionView.backgroundColor = UIColor.whiteColor;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
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

-(void)configureSearchBar {
    UIView *searchBarContainer = [UIView new];
    UISearchBar *searchBar = [UISearchBar new];
    
    [searchBarContainer addSubview: searchBar];
    [self.view addSubview:searchBarContainer];
    
    [searchBarContainer setBackgroundColor:UIColor.whiteColor];
    [searchBarContainer setTranslatesAutoresizingMaskIntoConstraints: FALSE];
    
    [searchBar setReturnKeyType: UIReturnKeyDone];
    [searchBar setAutocorrectionType: UITextAutocorrectionTypeNo];
    [searchBar setTranslatesAutoresizingMaskIntoConstraints: FALSE];
    [searchBar setBackgroundColor: UIColor.lightGrayColor];
    [searchBar setTintColor: UIColor.blackColor];
    [searchBar setPlaceholder: @"Search"];
    [searchBar setBackgroundImage: [UIImage new]];
    [searchBar setTranslucent: FALSE];
    [searchBar setEnablesReturnKeyAutomatically: FALSE];
    
    [searchBarContainer.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-60].active = TRUE;
    [searchBarContainer.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = TRUE;
    
    [searchBarContainer.leftAnchor constraintEqualToAnchor: self.view.leftAnchor].active = TRUE;
    [searchBarContainer.rightAnchor constraintEqualToAnchor: self.view.rightAnchor].active = TRUE;
    
    [searchBar.topAnchor constraintEqualToAnchor: searchBarContainer.topAnchor].active = TRUE;
    [searchBar.leftAnchor constraintEqualToAnchor: searchBarContainer.leftAnchor].active = TRUE;
    [searchBar.rightAnchor constraintEqualToAnchor: searchBarContainer.rightAnchor].active = TRUE;
    [searchBar.heightAnchor constraintEqualToConstant: 60].active = TRUE;
    
    searchBar.delegate = self;
    
    self.searchBarContainer = searchBarContainer;
}

-(void)setIsLoaded {
    [self.collectionView setUserInteractionEnabled: TRUE];
    [self.activityView stopAnimating];
}

-(void)setIsLoadingProgress {
    [self.activityView startAnimating];
    [self.collectionView setUserInteractionEnabled: FALSE];
    
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
    
    [self.noItemsLabel setText: [NSString stringWithFormat:@"No items found for `%@`", search]];
}

- (void)addNextItems:(NSArray<GifSearchItem *> *)items {
    self.dataSourceItems = [self.dataSourceItems arrayByAddingObjectsFromArray:items];
    [self.collectionView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.presenter setSearch: searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize estimatedSize = CGSizeMake(collectionView.bounds.size.width / 2, collectionView.bounds.size.width / 2);
    
    GifCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GifCollectionViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = UIColor.magentaColor;
    
    NSURL *url = self.dataSourceItems[indexPath.item].originalUrl;
    
    [cell updateURL: url estimatedSize: estimatedSize];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width / 2, collectionView.bounds.size.width / 2);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height - (scrollView.contentOffset.y) < 1000) {
        [self.presenter loadNextPage];
    }
}

@end
