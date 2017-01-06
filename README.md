# WeePager

A simple, funny and fully customizable pager for iOS. Wee!


## Installation
At the moment the library is in my personal pod repo.
Add this to your Podfile
```ruby
source 'https://github.com/FedeGens/FedeGensPodSpecs.git'
```
And add this too.
```ruby
use_frameworks!
pod 'WeePager'
```
Alternatively you can just import the classes from this repo

##Requirements
- iOS 8.0+ 
- Swift 3.0

## How to use

###Initialize WeePager

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

###Set your pages

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

###Customization

Here we are! We have fully initialized our pager with a few lines of code. And now? **Personalize it!**
######-->TODO: Write customization guide

## App using WeePager
If you use this lib [contact me](mailto:fgentile95dev@icloud.com?subject=WeePager) and I will add it to the list below:

###Developed By
Federico Gentile - [fgentile95dev@icloud.com](mailto:fgentile95dev@icloud.com)

## License
```
The MIT License (MIT)

Copyright (c) 2016 Raphaël Bussa

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
