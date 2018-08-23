## Wafer Coding Challenge

Country Viewing App

## Building And Running The Project (Requirements)
* Swift 2.3+
* Xcode 8
* iOS 10.0+

## Architecture
This application uses the Model-View-ViewModel (refered to as MVVM) architecture. The main purpose of the MVVM is to move the data state from the View to the ViewModel.

`The Following is gotten from: https://www.toptal.com/ios/swift-tutorial-introduction-to-mvvm`

### Model
In the MVVM design pattern, Model is the same as in MVC pattern. It represents simple data.

### View
View is represented by the UIView or UIViewController objects, accompanied with their .xib and .storyboard files, which should only display prepared data. (We don’t want to have NSDateFormatter code, for example, inside the View.)

### ViewModel
Only a simple, formatted string that comes from the ViewModel.

ViewModel hides all asynchronous networking code, data preparation code for visual presentation, and code listening for Model changes. All of these are hidden behind a well-defined API modeled to fit this particular View.

One of the benefits of using MVVM is testing.

## Walkthrough Fetching Countries

### CountryManager / CountryManagerProtocol
In the CountryManagerProtocol, we have a protocol that has a `fetchcountries(completion: ...)`

CountryManager Implements this, and provides an implementation for `fetchcountries(completion: ...)`

### Testing Country Mananeger
Unit test was writing for testing countrymanager / Delegate. I tested for the following:
* Test For success by mocking it
* Test for bad data by mocking it also
* Test Manager itself by checking for reachability before utilizing it

### CountryViewViewModel
Here, we initialized CountryManagerProtocol and perform country data fetching, pagination, passing data to view when done

### Testing CountryViewViewModel
I ran test for:
* Loading stat
* Successful data
* Error Fetching data

### CountryTableViewCell
This here, displays information about a tableview.

## Task / Solution

### Solving Task Given To Implement On Cell:
* It should have an anchor point for where the swipe just shows the delete icon.
* On a fast swipe past anchor point the row should delete.
* On a slow swipe past anchor point, swiped area should swipe back to anchor point showing the delete icon
* On a slow swipe till anchor point, the swipe should get cancelled.
* Clicking/Swiping any other row should cancel the current swipe.

### Solution
* Setup Gesture recognizer and slide action views
* In the `gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool` I ensured swipe is enabled only alog x axis
* When moving view, make sure every moving view is in sync by using the centerPoint and leftAnchorConstraint
* If pan velocity of view goes beyond the 1000 point threshold, view should be deleted
* If delete button is clicked, it should delete
* If slow swiped to anchor-point, it should return
* If slow swiped past anchor-point it should return to anchor-point
* Clicking / Swipping any other cell dismisses any other active cell by checking if a cell is active. I achieved this bu making sure that evey time a new cell wants to swipe, I keep a reference of it
