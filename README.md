CS3217 Problem Set 5
====================

**Name:** Huang Lie Jun

**Matric No:** A0123994W

**Tutor:** Irvin Lim

Tips
----
1.  CS3217's Gitbook is at <https://www.gitbook.com/book/cs3217/problem-sets/details>. Do visit the Gitbook often, as it contains all things relevant to CS3217. You can also ask questions related to CS3217 there.
2.  Take a look at `.gitignore`. It contains rules that ignores the changes in certain files when committing an Xcode project to revision control. (This is taken from <https://github.com/github/gitignore/blob/master/Swift.gitignore>).
3.  A Swiftlint configuration file is provided for you. It is recommended for you to use Swiftlint and follow this configuration. Keep in mind that, ultimately, this tool is only a guideline; some exceptions may be made as long as code quality is not compromised.
4.  Do not burn out. Have fun!


Rules of Your Game
------------------
> **Rules** &nbsp; `0 points`
>
> Describe the rules of your game and how the game works in a file called README.md. Although the rules are not graded, it gives the players (which includes your tutors) expectations on how the game is supposed to behave, so as to distinguish between features and bugs.

In PokeMania, you get to play a game of Bubble Blast as a Pokémon Trainer! The rules are similar to the typical Bubble Blast, except we have different types of bubbles.

Energy bubbles are your basic bubbles with an energy type. Match more than 2 bubbles with the same energy and you will score!

Effect bubbles are slightly different. They come with effects that either affects different type (in some cases more than 1 type due to Pokémon multi types), or affect the area around them.
e.g. Multi-Type Effect: Sunny Day affects both Fire and Grass type

Effect bubbles generally have some form of score multiplier that will increase the amount of points earned from combos. Some effects such as Payday will have even greater score multiplier (money shots).

Obstacle bubbles are bubbles that are indestructible! Some obstacles also have traits such as magnetic attraction that will affect the movement of your launched bubble.


Pod Setup
---------
(write something here)


Problem 1: Cannon Direction
---------------------------
(write something here)

> **Question 1** &nbsp; `5 points`
>
> Explain in README.md how the user is supposed to select the cannon direction.

The player can select the cannon direction either by tapping on the screen or by panning across the screen. The direction that the bubble is launched in will depend on the point where the player lifts his or her finger from the screen. The game is designed to restrict the angle of launch from -80deg to 80deg and with a limit on the rate of firing. If the cannon is forced to fire at rapid rate, it will disobey the trainer.


Problem 2: Upcoming Bubbles
---------------------------
(write something here)

> **Question 2** &nbsp; `5 points`
>
> It will be helpful for the user if they are given the colors of the next few bubbles to better plan their shots. Your task is to come up with an algorithm to decide on the colors of the next few bubbles and justify it in README.md.

The energy bubbles for launch are selected randomly in a resizable launch buffer queue. The energy types are picked from the energy types on screen. For instance, if your design involves 6 types (fire, water, grass, ground, rock, flying), I will match them with the respective types. These energy types will be made available in the launch buffer (upcoming bubbles). The buffer display is placed on the launcher body. To make it trickier, I only allowed 1 buffer on display, though I have a buffer queue of size 3.


Problem 3: Integration
----------------------
(write something here)

> **Question 3** &nbsp; `10 points`
>
> Describe in the file README.md how your design allowed the integration of the game engine. Explain the advantages and disadvantages of your approach and alternative approaches.

The Game Engine is integrated with the a view controller using a GameDelegate. This GameDelegate specifies the contract between the engine and the required UI elements and real estate for the GameEngine to handle and take over. Examples are the grid view, the dock view, the dashboard view and the main view. This design allowed me to re-create the game view controller by conforming to the delegate protocol, and specifying the required views in container views. Without the need to worry about what will happen inside these containers, I am free to re-create the game using any UIViewController, as long as I have an accompanying collection view. To integrate the created game view controller, I just have to segue from the menu view or the designer view.

The disadvantages of designing the Game Engine based on the delegates would be that the delegate methods would increase and scale according to the complexity of the game and its interface. This would lead to heavy coupling between the game controller and the engine. Also, since the game still relies on a collection view, the view logic leaks from the renderer into the delegated view, in terms of controlling the number of rows and columns of the grid, dimensions, etc.

The advantages of this design would be that it is easy to comprehend the contracts between the engine and the controller. It also allows some freedom in adjusting the main sections or views of the game by wrapping them in container views.


Problem 4: Special Bubbles
--------------------------
(write something here)

### Problem 4.4
> **Question 4.4** &nbsp; `5 points`
>
> Explain in the file README.md your general strategy for implementing these special bubble behaviours and support for chaining activation. Explain why your strategy is the best among alternatives.

When a bubble is added to the grid, I will check its immediate neighbours for effect bubbles. Then, I will a) search for matching energy and also b) get all bubbles affected by the effect(s). These 2 mechanism are handled separately and the order is determined by the different effect types.

Then for all effects that are found (connected to the bubble), I will obtain the affected bubbles by applying the effect rule. Then, for effect bubbles that are in this obtained set and are not in the previous set, I will apply their effects to obtain their affected bubbles. For every set of bubbles acquired from the effects, I will update the score along with the effect multipliers.

I prefer this strategy as it gives me freedom to determine the order and behaviour between effects and type chaining. This means that it is possible to create effects such as wild card bubbles in the future, since I can apply effects first (to inherit the type of the projectile) before chaining the bubble combos.

This design also allows me to track the scores well, since the effect multiplier is applied only to the bubbles that are affected directly by that effect.


Problem 5: Additional Game Features
-----------------------------------
(write something here)


Problem 6: Game Flow
--------------------
(write something here)


Problem 7: Class Diagram
------------------------
> **Question 7** &nbsp; `20 points`
>
> Draw the class diagram for the basic implementation of your game (i.e. you do not need to include the bells and whistles). Save your diagram as class-diagram.png and include it in the root directory of your repository for submission. Also give descriptions of the high-level purposes of the important classes in the README.md file. If you would like to add more diagrams that you find helpful in allowing others to understand your code architecture, feel free to add them in, and indicate it inside README.md.

(Please save your diagram as `class-diagram.png` in the root directory of the repository.)

![Class Diagram](/class-diagram-2.png)

![Class Diagram](/class-diagram.png)


Problem 8: Testing
------------------
> **Question 8** &nbsp; `40 points`
>
> Please describe your testing strategy in README.md. The testing strategy should also include the testing strategies for Problem Sets 3 and 4, since these are components of the final application. If you did your testing perfectly in the previous problem sets, you only need to replicate what you did earlier; if you didn't do so well, this is where you show that you've learnt something and update the tests.

### Black-box Testing

#### Single-Tap Launch

**Rationale:**
Ensure tap gesture functionality.

**Steps:**
1.  Tap once on a random spot on the screen.
2.  Check what happened on screen.
3.  Repeat on multiple spots on the screen.

**Expected Outcome:**
The launcher should rotate to face the direction tapped. A bubble will be seen appearing on screen if the tapped location is not near the bottom of the screen at steep angles.

#### Hold and Launch

**Rationale:**
Ensure hold gesture non-functionality.

**Steps:**
1.  Press and hold on the screen.
2.  Release.
3.  Repeat on multiple spots on the screen.

**Expected Outcome:**
The launcher should not move and no bubble should be seen appearing at the launcher area (assuming you managed to be still when holding onto the screen).

#### Pan and Launch

**Rationale:**
Ensure pan gesture functionality.

**Steps:**
1.  Press and drag your finger across the screen.
2.  Release.
3.  Repeat from multiple spots across the screen.

**Expected Outcome:**
The launcher should follow your movement (pan) across the screen and rotate. On release, a bubble should be launched from the launcher.

#### Movement

**Rationale:**
Ensure projectiles will move.

**Steps:**
1.  Tap on the screen to launch a bubble.
2.  Repeat on multiple spots across the screen.

**Expected Outcome:**
Bubbles should appear and move towards and past the tapped location until it deflects or collides. No bubble should be seen stuck without being inside a grid.

#### Launch Preview Consistency

**Rationale:**
Ensure the launch preview is functional.

**Steps:**
1.  Look at the launcher (Horsea). Look into it's right eye.
2.  Press and launch on the screen.
3.  Observe the launched bubble and its colour.
4.  Repeat for several times.

**Expected Outcome:**
Bubbles appearing on screen at launch should be consistent with the previously viewed preview colour (in Horsea's right eye).

#### Collision with Bubble (Different Type)

**Rationale:**
Ensure different-type collision functionality.

**Steps:**
1.  Tap and launch several times to generate some bubbles on the grid.
2.  Look at the launch preview and note the colour of the preview bubble.
3.  Aim at a bubble on the grid that has a different colour than the observed colour.
4.  Tap and launch the bubble.
5.  Ensure the bubble ends next to the targeted bubble.
6.  Observe the bubble to see if it animates or disappears.
7.  Repeat for bubbles of differing colour (pairs).

**Expected Outcome:**
The targeted bubbles should remain since they are of a different colour with the launched bubble.

#### Collision with Bubble (Same Type)

**Rationale:**
Ensure same-type collision functionality.

**Steps:**
1.  Tap and launch several times to generate some bubbles on the grid.
2.  Look at the launch preview and note the colour of the preview bubble.
3.  Aim at a bubble on the grid that has the same colour with the observed colour.
4.  Tap and launch the bubble.
5.  Ensure the bubble ends next to the targeted bubble.
6.  Observe the bubble to see if it animates or disappears.
7.  Repeat for bubbles of same colour (pairs).

**Expected Outcome:**
The targeted bubbles should animate or disappear if more than 3 continuously chained bubbles (including the launched bubble) share the same colour. Otherwise, the targeted bubbles should not animate or disappear (if you end up with less than 3 continous chained bubbles of the same type).

#### Collision with Top Wall

**Rationale:**
Ensure top-wall collision sets the bubble to grid.

**Steps:**
1.  Find an empty spot that is immediately in contact with the top wall.
2.  Aim and launch at that spot by tapping on that spot.
3.  Observe.
4.  Repeat on different spots along the top wall.

**Expected Outcome:**
The launched bubble should hit the top wall and stop, and enters the nearest slot on the grid.

#### Deflecting on Left Wall

**Rationale:**
Ensure bubble gets deflected off the left wall.

**Steps:**
1.  Find a clear, unobstructed path from the launcher to the left wall.
2.  Aim and launch along that path by tapping on the screen.
3.  Observe.
4.  Repeat at different angles, along the left wall.

**Expected Outcome:**
The launched bubble should hit the left wall, stop and deflect in the same incident angle of approach.

#### Deflecting on Right Wall

**Rationale:**
Ensure bubble gets deflected off the right wall.

**Steps:**
1.  Find a clear, unobstructed path from the launcher to the right wall.
2.  Aim and launch along that path by tapping on the screen.
3.  Observe.
4.  Repeat at different angles, along the right wall.

**Expected Outcome:**
The launched bubble should hit the right wall, stop and deflect in the same incident angle of approach.

#### Scoring Same Type Bubbles with Disconnection

**Rationale:**
Ensure bubble combinations of same colour disappears, along with the disconnected bubbles that result.

**Steps:**
1.  Tap and launch several times to generate some bubbles on the grid.
2.  Look at the launch preview and note the colour of the preview bubble.
3.  Aim at a bubble on the grid that has the same colour with the observed colour, forms a continuous chain of at least 2 other bubbles with the same type, and without these said bubbles, at least 1 bubble will be disconnected (no continuous path to reach the top wall).
4.  Tap and launch the bubble.
6.  Observe the bubbles to see if they animate or disappear.
7.  Repeat for bubbles of different colours.

**Expected Outcome:**
The said combination of bubbles should disappear (fade away), whereas the bubbles that are left disconnected should also be removed (flash twice). After, no bubbles should be left disconnected on the grid.

#### Close and Reopen

**Rationale:**
Ensure application does not hang or break after opening and closing.

**Steps:**
1.  Open the application.
2.  Swipe up from the bottom edge of the iPad to enter the multi-tasking mode, and quit the application by swiping it off the multi-tasking view.
3.  Re-launch the application.

**Expected Outcome:**
The application should still be accessible and should still load and be functional after closing and re-opening.

#### Hide and Switch Back

**Rationale:**
Ensure application is still usable after switching to another application and switching back.

**Steps:**
1.  Open the application.
2.  Press the home button.
3.  Launch another application.
4.  Swipe up from the bottom edge of the iPad to enter the multi-tasking mode.
5.  Return to the application by selecting it from the multi-tasking panel.

**Expected Outcome:**
The application should still be accessible and should still load and be functional after switching context. It should also retain all the bubbles and states from where you left it just before switching to another application.

#### Extreme Launch Angles

**Rationale:**
Ensure launch angles are handled succinctly.

**Steps:**
1.  Tap on the bottom left corner of the screen.
2.  Observe.
3.  Repeat by tapping along the left wall, from the bottom left corner and working your way upwards.
4.  Repeat this along the right wall, from the bottom right corner.

**Expected Outcome:**
At very steep angles (when tapping near or at the bottom left/right corners), the launcher should not launch any bubbles. However, as you work your way up, when the angle is less steep, you will see bubbles appearing at the launcher and moving upwards.

#### Rotation of Device

**Rationale:**
Ensure launch position is correct after orientating.

**Steps:**
1.  Tap on the screen to launch a bubble.
2.  A bubble will appear at the launcher. Note the position that it appears at.
3.  Rotate the iPad 180 degrees.
4.  Tap again on the screen to launch a bubble.
5.  Observe the location that the bubble appears.

**Expected Outcome:**
After orientating, the launch position should not change. The bubble launched should still start from the same location (on the launcher), regardless of whether you're in the portrait or inverse portrait orientation.

#### Different Device

**Rationale:**
Ensure size class support across devices.

**Steps:**
1.  Install and run the application on an iPhone.
2.  Try performing the series of black-box tests.
2.  Repeat on an iPad.

**Expected Outcome:**
The behaviour across devices of different screen size should be similar if not the same. The displays should scale nicely across different screen dimensions.

#### Deflect with Collide

**Rationale:**
Ensure collide is prioritized before deflection.

**Steps:**
1.  Tap and launch several times to generate some bubbles on the grid, especially near the left wall.
2.  Find a position in direct contact with the left wall and with another bubble.
4.  Tap and launch a bubble towards that position.
6.  Observe.
7.  Repeat for the right wall.

**Expected Outcome:**
When the bubble collides with both the wall and another bubble at the same time, it should prioritize settling / landing into a grid instead of deflecting (and moving).

#### Launch Rate

**Rationale:**
Ensure responsiveness in graphics.

**Steps:**
1.  Aim at a relatively free section in the grid.
2.  Tap and launch at a slow rate (1 tap every 3 seconds).
3.  Repeat for medium (1 tap every 1 seconds) and fast rate (1 tap every 0.5 seconds).

**Expected Outcome:**
When launching bubbles rapidly, the performance should not be reduced drastically. Noticeable lags should not be frequent, if not should not occur at all.

#### Hitting Corners

**Rationale:**
Ensure that corner cases are covered literally. To make sure the bubbles do not get stuck.

**Steps:**
1.  Aim at an empty top-left corner edge.
2.  Tap and launch.
3.  Repeat for an empty top-right corner edge.

**Expected Outcome:**
The bubble should land in a grid slot and not get stuck or confused.

#### Hitting Disappearing Bubbles

**Rationale:**
Ensure that bubble state is not mixed up when animating bubbles.

**Steps:**
1.  Setup the black-box test case where disconnected bubbles will be resulted from a chain of continuous (at least 3) bubbles of same type as the launched bubble.
2.  Tap and launch to clear the combination.
3.  Immediately after, aim, tap and launch a bubble towards 1 of the bubble that is disappearing.
4.  Repeat to hit both the disappearing and disconnected bubble, as well as the disappearing bubble with the same type as the scored combination.

**Expected Outcome:**
The disappearing bubble should continue to disappear. The launched bubble should land and take over the spot where the old bubbles disappear.

#### Leaving It Running

**Rationale:**
Ensure that the game loop does not increase in load over time.

**Steps:**
1.  Launch as many bubbles as you can rapidly.
2.  Leave the device on and application in the foreground (5 minutes).
3.  Repeat for launching bubbles slowly but over a period of time (5 minutes).

**Expected Outcome:**
The device should not overheat and the application should not become sluggish. If attached on XCode, the CPU and RAM consumption should not increase over time.


### White Box Testing

#### Control Flow for Effects and Scoring

**Rationale:**
Test control flow for scoring between effect bubbles.
g
**Steps:**
Check the behaviour of the bubbles when they are removed, whether the energy chains gets removed first or the effect chain gets applied and removed first.

**Expected Outcome:**
For Payday effect, the effect should be applied first, before the colour chain gets removed. For other effects, the colour chain gets removed first, before the effects are applied and affected bubbles removed.

#### Cell Size for Template View by device

**Rationale:**
The cell size for custom and preloaded designs in the game template and game gallery views depends on the device type. If a phone is used, it has less real estate to display multiple designs horizontally, so thumbnails are sized to the full screen width. For iPad, the screens are typically wider, so it can afford displaying up to 3 columns.

**Steps:**
Inspect the template cell size across different devices, based on the control flow of `UIDevice.current.userInterfaceIdiom`.

**Expected Outcome:**
For phones, there should be 1 column (full-width display). For iPads, there should be 3 columns on display.g


Problem 9: Bells and Whistles
------------------
> **Question 9** &nbsp; `75 points`
>
> You are free to add your own features to show off your creativity. Please describe ALL the extra features and improvements in the file README.md, so that your tutors can award you due credit. Briefly describe how you modified your original design to implement each feature. Be creative in this section! You may make use of Markdown formatting features to include diagrams and screenshots to better illustrate your point.
>
> You are allowed to use external resources (images and sound) to implement these, but please adhere to any licensing requirement and credit the original creators in the README.md file.

The following are the extra features added to this game.

1.  Design
The game is built with a minimalistic design. It's intuitive and appealing and handles user flows between different screens well with prompts and feedback.

2.  Animations
Animations have been added to the launcher and the bubbles. When firing the launcher, you will see the cannon bulge. When the bubbles are destroyed (or dropped on disconnection), you will also see specific animations of bursting and dropping.

3.  Score multipliers mechanics
Score system has been added to the game, along with multipliers for different types of bubbles. Normal bubbles have 1x multiplier, while effect bubbles have 1.5x multiplier. Payday effect yields a 5x multiplier.

4.  Additional effect bubbles have been added. They are:
    -   Payday: Adds a 5x multiplier to the energy (colour) streak.
    -   Rain Dance: An elemental effect that favours the water type. It will remove all water types in the field.
    -   Sunny Day: A multi-elemental effect that favours both the grass and fire type. It removes all grass and fire type energy bubbles in the field.
    -   Time Limit: To make things more exciting, I've added a time limit of 2 minutes per game session. If the player manages to clear all energy bubbles before the time runs out, the player will win the game.
    -   Pause and Resume option: With a time limit, the player might sometimes find a need to pause the game. This allows the player to enjoy the game without worrying about being unable to concentrate on the things around them. Would be useful when you are playing on commute.
    -   End Game screen: To notify the gamer of that the game has ended, the player is notified with a simple alert.


Problem 10: Final Reflection
------------------
> **Question 10** &nbsp; `10 points`
>
> Comment on the original design of your MVC architecture and also on the design of your game engine. Is it possible to further improve the design/architecture? If so, how? If not, why not?

Definitely. The improvements that can be made are:
-   Change GameEngine view delegates to instead of acquiring views, acquire areas or frames. This will allow me to render freely in these areas instead of depend on external views.
-   Remove dependency on collection view grid. To do so, I can set up my own calculations of the grid given a rectangle (CGRect) and the respective dimensions (bubble size).


Credits
------------------
Image Assets:
-   Energy Icons from Vecteezy by orangereebok
<https://www.vecteezy.com/vector-art/119820-free-type-pokemon-vector>

-   Pokemon Icons from Vecteezy by visionheldup
<https://www.vecteezy.com/vector-art/118593-pokemon-icon-vector-free>

-   Pokeballs Icons from Vecteezy by seabranddesign
<https://www.vecteezy.com/vector-art/117926-free-pokemon-icons-vector>

-   Shuffle Icon from FlatIcon by SmashIcons
<https://www.flaticon.com/free-icon/shuffle_149131#term=shuffle&page=1&position=2>

-   App Icon from FlatIcon by Roundicons Freebies
<https://www.flaticon.com/free-icon/squirtle_188988>

-   Launch Icon from FlatIcon by Roundicons Freebies
<https://www.flaticon.com/free-icon/crown_188970>

-   Pokemon GO Icons from FlatIcon by Roundicons Freebies
<https://www.flaticon.com/packs/pokemon-go>

-   Weather Icons from learnsketch.com
<https://www.learnsketch.com/freebies/flat-weather-icons>
