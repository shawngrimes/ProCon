//
//  V8HorizontalPickerView.m
//
//  Created by Shawn Veader on 9/17/10.
//  Copyright 2010 V8 Labs, LLC. All rights reserved.
//

#import "V8HorizontalPickerView.h"


#pragma mark -
#pragma mark Internal Method Interface
@interface V8HorizontalPickerView (InternalMethods)
- (void)collectData;

- (void)getNumberOfElementsFromDataSource;
- (void)getElementWidthsFromDelegate;
- (void)setTotalWidthOfScrollContent;
- (void)updateScrollContentInset;

- (void)addScrollView;
- (void)drawPositionIndicator;
- (V8HorizontalPickerLabel *)labelForForElementAtIndex:(NSInteger)index withTitle:(NSString *)title;
- (CGRect)frameForElementAtIndex:(NSInteger)index;

- (CGPoint)currentCenter;
- (void)scrollToElementNearestToCenter;
- (NSInteger)nearestElementToCenter;
- (NSInteger)nearestElementToPoint:(CGPoint)point;
- (NSInteger)elementContainingPoint:(CGPoint)point;

- (NSInteger)offsetForElementAtIndex:(NSInteger)index;
- (NSInteger)centerOfElementAtIndex:(NSInteger)index;

- (void)scrollViewTapped:(UITapGestureRecognizer *)recognizer;

- (NSInteger)tagForElementAtIndex:(NSInteger)index;
- (NSInteger)indexForElement:(UIView *)element;
@end


#pragma mark -
#pragma mark Implementation
@implementation V8HorizontalPickerView : UIView

@synthesize dataSource, delegate;
@synthesize numberOfElements, currentSelectedIndex; // readonly
@synthesize elementFont, textColor, selectedTextColor;
@synthesize selectionPoint, selectionIndicatorView, indicatorPosition;
@synthesize leftEdgeView, rightEdgeView;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		elementWidths = [[NSMutableArray array] retain];
		_reusableViews = [[NSMutableSet alloc] init];

		[self addScrollView];
		
		self.textColor   = [UIColor blackColor];
		self.elementFont = [UIFont systemFontOfSize:12.0f];

		numberOfElements     = 0;
		elementPadding       = 0;
		currentSelectedIndex = 0;
		dataHasBeenLoaded    = NO;
		scrollSizeHasBeenSet = NO;

		// default to the center
		selectionPoint = CGPointMake(frame.size.width / 2, 0.0f);
		indicatorPosition = V8HorizontalPickerIndicatorBottom;
		
		firstVisibleElement = -1;
		lastVisibleElement  = -1;
	}
    return self;
}

- (void)dealloc {
	[_scrollView    release];
	[elementWidths  release];
	[elementFont    release];
	[_reusableViews release];
	[leftEdgeView   release];
	[rightEdgeView  release];

	[textColor          release];
	[selectedTextColor  release];

	if (selectionIndicatorView) {
		[selectionIndicatorView release];
	}

    [super dealloc];
}

#pragma mark -
#pragma mark LayoutSubViews
- (void)layoutSubviews {
	[super layoutSubviews];

	if (!dataHasBeenLoaded) {
		[self collectData];
	}
	if (!scrollSizeHasBeenSet) {
		[self setTotalWidthOfScrollContent];
	}

	SEL titleForElementSelector = @selector(horizontalPickerView:titleForElementAtIndex:);
	SEL viewForElementSelector  = @selector(horizontalPickerView:viewForElementAtIndex:);
	SEL setSelectedSelector     = @selector(setSelectedElement:);

	CGRect visibleBounds = [self bounds];
	// remove any subviews that are no longer visible
	for (UIView *view in [_scrollView subviews]) {
		CGRect scaledViewFrame = [_scrollView convertRect:[view frame] toView:self];

        // if the view doesn't intersect, it's not visible, so we can recycle it
        if (!CGRectIntersectsRect(scaledViewFrame, visibleBounds)) {
			[_reusableViews addObject:view];
            [view removeFromSuperview];
        } else { // if it is still visible, update it's selected state
			if ([view respondsToSelector:setSelectedSelector]) {
				// view's tag is it's index
				BOOL isSelected = (currentSelectedIndex == [self indexForElement:view]);
				[(V8HorizontalPickerLabel *)view setSelectedElement:isSelected];
			}
		}
	}

	// find needed elements by looking at left and right edges of frame
	CGPoint offset = _scrollView.contentOffset;
	int firstNeededElement = [self nearestElementToPoint:CGPointMake(offset.x, 0.0f)];
	int lastNeededElement  = [self nearestElementToPoint:CGPointMake(offset.x + visibleBounds.size.width, 0.0f)];

	// add any views that have become visible
	UIView *view = nil;
	for (int i = firstNeededElement; i <= lastNeededElement; i++) {
		view = nil; // paranoia
		view = [_scrollView viewWithTag:[self tagForElementAtIndex:i]];
		if (!view) {
            if (i < numberOfElements) { // make sure we are not requesting data out of range
                if (self.delegate && [self.delegate respondsToSelector:titleForElementSelector]) {
                    NSString *title = [self.delegate horizontalPickerView:self titleForElementAtIndex:i];
                    view = [self labelForForElementAtIndex:i withTitle:title];
                } else if (self.delegate && [self.delegate respondsToSelector:viewForElementSelector]) {
                    view = [self.delegate horizontalPickerView:self viewForElementAtIndex:i];
                }

                if (view) {
                    // use the index as the tag so we can find it later
                    view.tag = [self tagForElementAtIndex:i];
                    [_scrollView addSubview:view];
                }
            }
		}
	}

	// save off what's visible now
	firstVisibleElement = firstNeededElement;
	lastVisibleElement  = lastNeededElement;
}

#pragma mark -
#pragma mark Getters and Setters
- (void)setDelegate:(id)newDelegate {
	if (delegate != newDelegate) {
		delegate = newDelegate;
		[self collectData];
	}
}

- (void)setDataSource:(id)newDataSource {
	if (dataSource != newDataSource) {
		dataSource = newDataSource;
		[self collectData];
	}
}

- (void)setSelectionPoint:(CGPoint)point {
	if (!CGPointEqualToPoint(point, selectionPoint)) {
		selectionPoint = point;
		[self updateScrollContentInset];
	}
}

// allow the setting of this views background color to change the scroll view
- (void)setBackgroundColor:(UIColor *)newColor {
	[super setBackgroundColor:newColor];
	_scrollView.backgroundColor = newColor;
	// TODO: set all subviews as well?
}

- (void)setIndicatorPosition:(V8HorizontalPickerIndicatorPosition)position {
	if (indicatorPosition != position) {
		indicatorPosition = position;
		[self drawPositionIndicator];
	}
}

- (void)setSelectionIndicatorView:(UIView *)indicatorView {
	if (selectionIndicatorView != indicatorView) {
		if (selectionIndicatorView) {
			[selectionIndicatorView removeFromSuperview];
			[selectionIndicatorView release];
		}
		selectionIndicatorView = [indicatorView retain];

		[self drawPositionIndicator];
	}
}

- (void)setLeftEdgeView:(UIView *)leftView {
	if (leftEdgeView != leftView) {
		if (leftEdgeView) {
			[leftEdgeView removeFromSuperview];
			[leftEdgeView release];
		}
		leftEdgeView = [leftView retain];
		
		CGRect tmpFrame = leftEdgeView.frame;
		tmpFrame.origin.x = 0.0f;
		tmpFrame.origin.y = 0.0f;
		leftEdgeView.frame = tmpFrame;
		[self addSubview:leftEdgeView];
	}
}

- (void)setRightEdgeView:(UIView *)rightView {
	if (rightEdgeView != rightView) {
		if (rightEdgeView) {
			[rightEdgeView removeFromSuperview];
			[rightEdgeView release];
		}
		rightEdgeView = [rightView retain];
		
		CGRect tmpFrame = rightEdgeView.frame;
		tmpFrame.origin.x = self.frame.size.width - tmpFrame.size.width;
		tmpFrame.origin.y = 0.0f;
		rightEdgeView.frame = tmpFrame;
		[self addSubview:rightEdgeView];
	}
}

#pragma mark -
#pragma mark Reload Data Method
- (void)reloadData {
	// remove all scrollview subviews and "recycle" them
	for (UIView *view in [_scrollView subviews]) {
		[_reusableViews addObject:view];
		[view removeFromSuperview];
	}

	firstVisibleElement = NSIntegerMax;
	lastVisibleElement  = NSIntegerMin;

	
	[self collectData];

	[self setNeedsLayout];
}

- (void)collectData {
	scrollSizeHasBeenSet = NO;
	dataHasBeenLoaded    = NO;

	[self getNumberOfElementsFromDataSource];
	[self getElementWidthsFromDelegate];
	[self setTotalWidthOfScrollContent];
	[self updateScrollContentInset];

	dataHasBeenLoaded = YES;
}

#pragma mark -
#pragma mark Scroll To Element Method
- (void)scrollToElement:(NSInteger)index animated:(BOOL)animate {
	int x = [self centerOfElementAtIndex:index] - selectionPoint.x;
	[_scrollView setContentOffset:CGPointMake(x, 0) animated:animate];
	currentSelectedIndex = index;

	// notify delegate of the selected index
	SEL delegateCall = @selector(horizontalPickerView:didSelectElementAtIndex:);
	if (self.delegate && [self.delegate respondsToSelector:delegateCall]) {
		[self.delegate horizontalPickerView:self didSelectElementAtIndex:index];
	}
}


#pragma mark -
#pragma mark Reusable View
// TODO: use this
- (UIView *)dequeueReusableView {
    UIView *view = [_reusableViews anyObject];
    if (view) {
        [[view retain] autorelease];
        [_reusableViews removeObject:view];
    }
    return view;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	// set the current item under the center to "highlighted" or current
	currentSelectedIndex = [self nearestElementToCenter];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	// only do this if we aren't decelerating
	if (!decelerate) {
		[self scrollToElementNearestToCenter];
	}
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//	[self scrollToElementNearestToCenter];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self scrollToElementNearestToCenter];
}

#pragma mark -
#pragma mark View Creation Methods (Internal Methods)
- (void)addScrollView {
	if (_scrollView == nil) {
		_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		_scrollView.delegate = self;
		_scrollView.scrollEnabled = YES;
		_scrollView.scrollsToTop  = NO;
		_scrollView.showsVerticalScrollIndicator   = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.bouncesZoom  = NO;
		_scrollView.alwaysBounceHorizontal = YES;
		_scrollView.alwaysBounceVertical   = NO;
		_scrollView.minimumZoomScale = 1.0; // setting min/max the same disables zooming
		_scrollView.maximumZoomScale = 1.0;
		_scrollView.contentInset = UIEdgeInsetsZero;
		_scrollView.decelerationRate = 0.1; //UIScrollViewDecelerationRateNormal;
		
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
		[_scrollView addGestureRecognizer:tapRecognizer];
		[tapRecognizer release];
		
		[self addSubview:_scrollView];
	}
}

- (void)drawPositionIndicator {
	CGFloat x = self.selectionPoint.x - (selectionIndicatorView.frame.size.width / 2);
	CGFloat y;

	switch (self.indicatorPosition) {
		case V8HorizontalPickerIndicatorTop: {
			y = 0.0f;
			break;
		}
		case V8HorizontalPickerIndicatorBottom: {
			y = self.frame.size.height - selectionIndicatorView.frame.size.height;
			break;
		}
		default:
			break;
	}

	// properly place indicator image in view relative to selection point
	CGRect tmpFrame = CGRectMake(x, y,
								 selectionIndicatorView.frame.size.width,
								 selectionIndicatorView.frame.size.height);
	selectionIndicatorView.frame = tmpFrame;
	[self addSubview:selectionIndicatorView];
}

// create a UILabel for this element.
- (V8HorizontalPickerLabel *)labelForForElementAtIndex:(NSInteger)index withTitle:(NSString *)title {
	CGRect labelFrame     = [self frameForElementAtIndex:index];
	V8HorizontalPickerLabel *elementLabel = [[V8HorizontalPickerLabel alloc] initWithFrame:labelFrame];

	elementLabel.textAlignment   = UITextAlignmentCenter;
	elementLabel.backgroundColor = self.backgroundColor;
	elementLabel.text            = title;
	elementLabel.font            = self.elementFont;
	
	elementLabel.normalStateColor   = self.textColor;
	elementLabel.selectedStateColor = self.selectedTextColor;
	elementLabel.selectedElement    = (currentSelectedIndex == index);

	return [elementLabel autorelease];
}

- (void)adjustViewState {
}

#pragma mark -
#pragma mark DataSource Calling Method (Internal Method)
- (void)getNumberOfElementsFromDataSource {
	SEL dataSourceCall = @selector(numberOfElementsInHorizontalPickerView:);
	if (self.dataSource && [self.dataSource respondsToSelector:dataSourceCall]) {
		numberOfElements = [self.dataSource numberOfElementsInHorizontalPickerView:self];
	}
}

#pragma mark -
#pragma mark Delegate Calling Method (Internal Method)
- (void)getElementWidthsFromDelegate {
	SEL delegateCall = @selector(horizontalPickerView:widthForElementAtIndex:);
	[elementWidths removeAllObjects];
	for (int i = 0; i < numberOfElements; i++) {
		if (self.delegate && [self.delegate respondsToSelector:delegateCall]) {
			NSInteger width = [self.delegate horizontalPickerView:self widthForElementAtIndex:i];
			[elementWidths addObject:[NSNumber numberWithInteger:width]];
		}
	}
}

#pragma mark -
#pragma mark View Calculation and Manipulation Methods (Internal Methods)
// what is the total width of the content area?
- (void)setTotalWidthOfScrollContent {
	NSInteger totalWidth = 0;
	for (int i = 0; i < numberOfElements; i++) {
		totalWidth += [[elementWidths objectAtIndex:i] intValue];
		totalWidth += elementPadding;
	}

	if (_scrollView) {
		// create our scroll view as wide as all the elements to be included
		_scrollView.contentSize = CGSizeMake(totalWidth, self.bounds.size.height);
		scrollSizeHasBeenSet = YES;
	}
}

// reset the content inset of the scroll view based on centering first and last elements.
- (void)updateScrollContentInset {
	// update content inset if we have element widths
	if ([elementWidths count] != 0) {
		CGFloat scrollerWidth = _scrollView.frame.size.width;

		CGFloat halfFirstWidth = [[elementWidths objectAtIndex:0] floatValue] / 2.0; 
		CGFloat halfLastWidth  = [[elementWidths lastObject] floatValue]      / 2.0;
		
		// calculating the inset so that the bouncing on the ends happens more smooothly
		// - first inset is the distance from the left edge to the left edge of the
		//     first element when that element is centered under the selection point.
		//     - represented below as the # area
		// - last inset is the distance from the right edge to the right edge of
		//     the last element when that element is centered under the selection point.
		//     - represented below as the * area
		//
		//        Selection
		//  +---------|---------------+
		//  |####| Element |**********| << UIScrollView
		//  +-------------------------+
		CGFloat firstInset = selectionPoint.x - halfFirstWidth;
		CGFloat lastInset  = (scrollerWidth - selectionPoint.x) - halfLastWidth;

		_scrollView.contentInset = UIEdgeInsetsMake(0, firstInset, 0, lastInset);
	}
}

// what is the left-most edge of the element at the given index?
- (NSInteger)offsetForElementAtIndex:(NSInteger)index {
	NSInteger offset = 0;
	if (index >= [elementWidths count]) {
		return 0;
	}

	for (int i = 0; i < index; i++) {
		offset += [[elementWidths objectAtIndex:i] intValue];
		offset += elementPadding;
	}
	return offset;
}

// return the tag for an element at a given index
- (NSInteger)tagForElementAtIndex:(NSInteger)index {
	return (index + 1) * 10;
}

// return the index given an element's tag
- (NSInteger)indexForElement:(UIView *)element {
	return (element.tag / 10) - 1;
}

// what is the center of the element at the given index?
- (NSInteger)centerOfElementAtIndex:(NSInteger)index {
	if (index >= [elementWidths count]) {
		return 0;
	}
	
	NSInteger elementOffset = [self offsetForElementAtIndex:index];
	NSInteger elementWidth  = [[elementWidths objectAtIndex:index] intValue] / 2;
	return elementOffset + elementWidth;
}

// what is the frame for the element at the given index?
- (CGRect)frameForElementAtIndex:(NSInteger)index {
	return CGRectMake([self offsetForElementAtIndex:index],
					  0.0f,
					  [[elementWidths objectAtIndex:index] intValue],
					  self.frame.size.height);
}

// what is the "center", relative to the content offset and adjusted to selection point?
- (CGPoint)currentCenter {
	CGFloat x = _scrollView.contentOffset.x + selectionPoint.x;
	return CGPointMake(x, 0.0f);
}

// what is the element nearest to the center of the view?
- (NSInteger)nearestElementToCenter {
	return [self nearestElementToPoint:[self currentCenter]];
}

// what is the element nearest to the given point?
- (NSInteger)nearestElementToPoint:(CGPoint)point {
	for (int i = 0; i < numberOfElements; i++) {
		CGRect frame = [self frameForElementAtIndex:i];
		if (CGRectContainsPoint(frame, point)) {
			return i;
		} else if (point.x < frame.origin.x) {
			// if the center is before this element, go back to last one,
			//     unless we're at the beginning
			if (i > 0) {
				return i - 1;
			} else {
				return 0;
			}
			break;
		} else if (point.x > frame.origin.y) {
			// if the center is past the last element, scroll to it
			if (i == numberOfElements - 1) {
				return i;
			}
		}
	}
	return 0;
}

// similar to nearestElementToPoint: however, this method does not look past beginning/end
- (NSInteger)elementContainingPoint:(CGPoint)point {
	for (int i = 0; i < numberOfElements; i++) {
		CGRect frame = [self frameForElementAtIndex:i];
		if (CGRectContainsPoint(frame, point)) {
			return i;
		}
	}
	return -1;
}

// move scroll view to position nearest element under the center
- (void)scrollToElementNearestToCenter {
	[self scrollToElement:[self nearestElementToCenter] animated:YES];
}

// use the gesture recognizer to slide to element under tap
- (void)scrollViewTapped:(UITapGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateRecognized ) {
		CGPoint tapLocation    = [recognizer locationInView:_scrollView];
		NSInteger elementIndex = [self elementContainingPoint:tapLocation];
		if (elementIndex != -1) { // point not in element
			[self scrollToElement:elementIndex animated:YES];
		}
	}
}

@end


// ------------------------------------------------------------------------
@implementation V8HorizontalPickerLabel : UILabel

@synthesize selectedElement, selectedStateColor, normalStateColor;

- (void)setSelectedElement:(BOOL)selected {
	if (selectedElement != selected) {
		if (selected) {
			self.textColor = self.selectedStateColor;
		} else {
			self.textColor = self.normalStateColor;
		}
		selectedElement = selected;
		[self setNeedsLayout];
	}
}

- (void)setNormalStateColor:(UIColor *)color {
	if (normalStateColor != color) {
		[normalStateColor release];
		normalStateColor = [color retain];
		self.textColor = normalStateColor;
		[self setNeedsLayout];
	}
}

@end