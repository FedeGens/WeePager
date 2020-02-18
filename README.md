# WeePager

WeePager is a simple, funny and fully customizable pager for iOS. Wee!


## Installation
Using Cocoapods:

Swift 5:
```ruby
use_frameworks!
pod 'WeePager'
```
Swift 4:
```ruby
use_frameworks!
pod 'WeePager', :git => 'https://github.com/FedeGens/WeePager.git', :branch => 'swift4'
```

Alternatively you can just import the classes from "WeePager" folder.

## Requirements
- iOS 8.0+ 
- Swift 4.0+

## How to use

### Initialize WeePager

##### Storyboard
- Drag a UIView inside your UIViewController
- Set WeePager as your View Class
- Link an outlet on your UIViewController

##### Programmatically

```Swift
let yourWeePager = WeePager()
yourWeePager.frame = CGRect(x: 0, y: 0, width: yourWidth, height: yourHeight)
self.view.addsubview(yourWeePager)
```

### Set your pages

```Swift

var vcArr = [UIViewController]()
for i in 0...20 {
    let vc = UIViewController()
    vc.title = "page " + String(i)
    vcArr.append(vc)
}
yourWeePager.set(viewControllers: [UIViewController()], titles: nil, images: nil)
```
Create a **UIViewController array** and call "set" method to set your pages!
Pages titles are obtained from **UIViewController().title**. If you want you can create a **String array** and pass it as "titles" parameter, or use an **UIImage array** as "images" parameter to set images instead of texts.

**Easy, isn't it? ;D**

### Customization

Here we are! We have fully initialized our pager with a few lines of code. And now? **Personalize it!** </br>
There are a lot of properties we can modify to customize our **WeePager**. Let's discover them!

#### loadAllPages
```Swift
var loadAllPages: Bool = true
```
Loads all the pages before initializing WeePager

#### pagesOffLimit
```Swift
var pagesOffLimit : Int = 5
```
Loads the specified number of pages runtime if **loadAllPages** is false (Recommended: set loadAllPages true for better performance)

#### initialPage
```Swift
var initialPage : Int = 0
```
Set the inizial WeePager page

#### animateMenuSelectionScroll
```Swift
var animateMenuSelectionScroll : Bool = true
```
Animate the menu selection scroll

#### menuHeight
```Swift
var menuHeight : CGFloat = 50
```
Set the menu height

#### menuPosition
```Swift
var menuPosition : menuPosition = .top
```
Set the menu position. It can be **.top** or **.bottom**

#### menuPosition
```Swift
var menuBackgroundColor : UIColor = .white
```
Set the menu background color

#### menuInset
```Swift
var menuInset : CGFloat = 32
```
Set the menu elements distance from left and right border

#### separatorHeight
```Swift
 var separatorHeight : CGFloat = 0
```
Set the menu separator height

#### separatorColor
```Swift
var separatorColor : UIColor = .black
```
Set the menu separator color

#### separatorInset
```Swift
var separatorInset : CGFloat = 0
```
Set the menu separator distance from left and right border

#### separatorMarginTop
```Swift
var separatorMarginTop : CGFloat = 0
```
Set the menu separator distance from the top element

#### separatorMarginBottom
```Swift
var separatorMarginBottom : CGFloat = 0
```
Set the menu separator distance from the bottom element

#### itemMaxLines
```Swift
var itemMaxLines : Int = 1
```
Set the max number of lines that title must have

#### itemMinWidth
```Swift
var itemMinWidth : CGFloat = 50
```
Set the min width that menu item must have

#### itemMaxWidth
```Swift
var itemMaxWidth : CGFloat = 150
```
Set the max width that menu item must have

#### itemInset
```Swift
var itemInset : CGFloat = 16
```
Set the item distance between them

#### itemBoldSelected
```Swift
var itemBoldSelected : Bool = true
```
Set if selected menu item text is bold

#### itemCanColor
```Swift
var itemCanColor : Bool = true
```
Set if selected menu item can change color

#### itemColor
```Swift
var itemColor : UIColor = .gray
```
Set the menu item color

#### itemSelectedColor
```Swift
var itemSelectedColor : UIColor = .black
```
Set the menu item selection color

#### itemFontSize
```Swift
var itemFontSize : CGFloat = 17
```
Set the menu item font size

#### indicatorView
```Swift
var indicatorView : UIView = UIView()
```
Set a custom view to your selection indicator

#### indicatorColor
```Swift
var indicatorColor : UIColor = .black
```
Set the selection indicator color

#### indicatorWidthAnimated
```Swift
var indicatorWidthAnimated : Bool = true
```
Set if selection indicator width is animated (false if you want to set **indicatorWIdth**)

#### indicatorWidth
```Swift
var indicatorWidth : CGFloat = 50
```
Set the selection indicator width

#### indicatorHeight
```Swift
var indicatorHeight : CGFloat = 3
```
Set the selection indicator height

#### indicatorCornerRadius
```Swift
var indicatorCornerRadius : CGFloat = 2
```
Set the selection indicator corner radius

#### indicatorAlign
```Swift
var indicatorAlign : indicatorAlignment = .bottom
```
Set the selection indicator alignment. It can be **.top** **.middle** **.bottom**

#### indicatorAlpha
```Swift
var indicatorAlpha : CGFloat = 1.0
```
Set the selection indicator alpha

### Customization Example
You can easily change WeePager parameters programmatically or directly from Storyboard
```Swift
let myWeePager = WeePager()
        
myWeePager.menuHeight = 40
myWeePager.separatorHeight = 1
myWeePager.separatorColor = .lightGray
myWeePager.separatorInset = 16
myWeePager.itemFontSize = 15
myWeePager.indicatorAlign = .middle
myWeePager.indicatorHeight = 30
myWeePager.indicatorAlpha = 0.3
```
**Enjoy! ;D**

## App using WeePager
If you use this lib [contact me](mailto:fgentile95dev@icloud.com?subject=WeePager) and I will add it to the list below:

### Developed By
Federico Gentile - [fgentile95dev@icloud.com](mailto:fgentile95dev@icloud.com)

## License
```
The MIT License (MIT)

Copyright (c) 2016 Federico Gentile

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
