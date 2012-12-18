//
//  ZViewController.m
//  FontTest
//
//  Created by Leonid Lo on 12/18/12.
//  Copyright (c) 2012 PE-Leonid.Lo. All rights reserved.
//

#import "ZViewController.h"
#import "ZFontCell.h"

@interface ZViewController ()
@property (nonatomic, retain) NSArray * allFonts;
@property (nonatomic, retain) IBOutlet	UITableView *table;
@property (nonatomic, retain) UIColor	*selectedColor;
@property (nonatomic, retain) IBOutlet UIButton	*btn2x;
@property (nonatomic, assign) CGFloat	fontSize;
@end

@implementation ZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.fontSize = 20;
	self.selectedColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.allFonts = [self loadFonts];
	[self.table reloadData];
}

- (NSArray *)loadFonts {
	NSString *listPath = [[NSBundle mainBundle] pathForResource:@"FontsList.txt" ofType:nil];
	NSString *strAllFonts = [NSString stringWithContentsOfFile:listPath encoding:NSUTF8StringEncoding error:NULL];
	NSArray *arrFontnames = [strAllFonts componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSMutableArray *arrAllFonts = [NSMutableArray arrayWithCapacity:8];
	for (NSString *rawFontname in arrFontnames) {
		NSString *fontname = [rawFontname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if ([fontname hasPrefix:@"//"]) {
			//	skip comment
			continue;
		}
		
		fontname = [fontname stringByDeletingPathExtension];
		if (fontname.length == 0) {
			continue;
		}
		UIFont *font = [UIFont fontWithName:fontname size:self.fontSize];
		if (!font) {
			NSLog(@"Could not load font named : '%@'", fontname);
		}
		else {
			[arrAllFonts addObject:font];
		}
	}
	
	return arrAllFonts;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.allFonts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellID = @"ZFontCell";
	ZFontCell *cell = [self.table dequeueReusableCellWithIdentifier:cellID];
	if (!cell) {
		cell = [[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil][0];
	}
	UIFont *font = self.allFonts[indexPath.row];
	cell.labFontName.text = [NSString stringWithFormat:@"Name:'%@'", font.fontName];
	cell.labFontString.text = @"Hello, this is a test string";
	cell.labFontString.font = font;
	cell.labFontString.textColor = self.selectedColor;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.table deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)actSelColor:(UIButton *)sender {
	self.selectedColor = sender.backgroundColor;
	[self.table reloadData];
}

- (IBAction)act2x:(UIButton *)sender {
	self.btn2x.selected = !	self.btn2x.selected;
	self.fontSize = self.btn2x.selected ? 40 : 20;
	self.allFonts = [self loadFonts];
	[self.table reloadData];
}

@end
