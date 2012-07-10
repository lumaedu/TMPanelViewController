# TMPanelViewController

Present any view controller in a nice and playful container panel. 
There are 3 different types of presentation:
- Center
- Right
- Left

## Screenshots
![TMPanelViewController](http://twoshotsofcocoa.com/wp-content/uploads/2012/07/IMG_0035.png)
![TMPanelViewController](http://twoshotsofcocoa.com/wp-content/uploads/2012/07/IMG_0036.png)

## How to use
Simply drag everything on the TMPanelViewController group folder from this project onto your project. Make sure to include the categories.

### Step 1
Initialize the view controller you would like to present in a panel
```
Ex: EMGithubProfileViewController *profile = [[EMGithubProfileViewController alloc] initWithNibName:@"EMGithubProfileViewController" bundle:nil];
```

### Step 2
Initialize a TMPanelViewController with the view controller that you would like to present.
Set the properties to customize the presentation
- presentationMode: center, right or left
- panelContentInsets: padding for the presented view controller's view
- shouldShowCloseButton: if close button is shown, tap outside to dismiss will be disabled.
- panelContentSize: if not defined, the panel view controller will read the contentSizeForViewInPopover property on the presented view controller.

```
_currentPanelController = [[TMPanelViewController alloc] initWithContentViewController:profile];
[_currentPanelController setPanelContentInsets:UIEdgeInsetsZero];
[_currentPanelController setDelegate:self];
[_currentPanelController setPresentationMode:kTMPanelViewPresentationModeRight];
[_currentPanelController presentPanel];
```

### Step 3
Implement the TMPanelViewController delegate methods (optional).
```
- (BOOL)panelControllerShouldDismissPanel:(TMPanelViewController *)panelController {
    // return NO and tap outside to dismiss will be disabled
    return YES;
}

- (void)panelControllerDidDismissPanel:(TMPanelViewController *)panelController {
   //Called after the panel was dismissed
    _currentPanelController = nil;
}
```

## Contact

Emerson Malca
- http://github.com/emersonmalca
- http://twitter.com/emersonmalca

## License
(The MIT License)

Copyright (c) 2012 Emerson Malca

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.