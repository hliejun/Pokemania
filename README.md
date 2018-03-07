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

(your answer here)


Problem 8: Testing
------------------
> **Question 8** &nbsp; `40 points`
>
> Please describe your testing strategy in README.md. The testing strategy should also include the testing strategies for Problem Sets 3 and 4, since these are components of the final application. If you did your testing perfectly in the previous problem sets, you only need to replicate what you did earlier; if you didn't do so well, this is where you show that you've learnt something and update the tests.

(your answer here)


Problem 9: Bells and Whistles
------------------
> **Question 9** &nbsp; `75 points`
>
> You are free to add your own features to show off your creativity. Please describe ALL the extra features and improvements in the file README.md, so that your tutors can award you due credit. Briefly describe how you modified your original design to implement each feature. Be creative in this section! You may make use of Markdown formatting features to include diagrams and screenshots to better illustrate your point.
>
> You are allowed to use external resources (images and sound) to implement these, but please adhere to any licensing requirement and credit the original creators in the README.md file.

(your answer here)


Problem 10: Final Reflection
------------------
> **Question 10** &nbsp; `10 points`
>
> Comment on the original design of your MVC architecture and also on the design of your game engine. Is it possible to further improve the design/architecture? If so, how? If not, why not?

(your answer here)
