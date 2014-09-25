CSE535_PRS
==========

Contains .xcworkspace and Podfile.

To run this project:
 - Clone the repository
 - In terminal cd to the cloned directory and run `pod install`
  - If you don't have cocoapods run `sudo gem install cocoapods`
 - Open up the PaperScissorsRock.xcworkspace file (the PaperScissorsRock.xcodeproj does not work with cocoapods)

To play using accelerometer:
- Click on the "Play using accelerometer" button, you'll have 3 seconds to make your selection.
- You can reselect a choice within the 3 seconds by click on the same button, but now says "Restart".
- X axis represents scissors, Y axis represents rock, and Z axis represents paper.
- Simply shake downwards on the chosen axis to make a seleciton.
