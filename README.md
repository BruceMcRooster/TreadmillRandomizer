<div align="center">
  <img src="TreadmillRandomizer/Assets.xcassets/AppIcon.appiconset/DiceOnTreadmill.png" alt="Logo" width="80" height="80">
</div>
<h3 align="center">Treadmill Randomizer</h3>

## What is this?

As a runner who frequently refers to treadmills as "dreadmills,"
I don't particularly enjoy when I have to run on the [19th century torture device](https://www.nytimes.com/wirecutter/blog/history-of-the-treadmill/).
I created this app in an attempt to spice it up.

The method is in the name. Put in the details of your run (time, speed range, and elevation range),
and the app will, at regular intervals, prompt you to change up your treadmill configuration a little,
complete with a ticking timer and some sound effects ([how to](https://stackoverflow.com/a/31126202)).

If you find this handy or have a similar "fondness" for treadmills, feel free to star this repo.

## Installation

This is, I can assure you, never going to be an official app store app in its current state.
However, with a free developer account and Xcode installed, you can install this app on your device
(works on iOS, untested but should work on iPad).

1. Clone repo (`git clone https://github.com/BruceMcRooster/TreadmillRandomizer.git`)
2. Open in Xcode (`xed TreadmillRandomizer`)
3. Set your team in Xcode (personal teams work)
    1. Select the `xcodeproj` file at the root of the file explorer
    2. Go to the "Signing & Capabilities" menu
    3. Select a team
4. Select a device and hit run. Hit stop once the app fully loads. I recommend a physical phone, where a free developer account will let the app stay available for a week. If it errors out as unavailable after that week, connect the phone again and hit run.
