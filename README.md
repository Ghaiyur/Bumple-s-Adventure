# Bumple-s-Adventure
A 2D platformer

## Dev log
- [x] [Windfiled](https://github.com/a327ex/windfield) is easier than love.physics
    - [x] Set up collidors, most of the functions are being called with colon
- [x] Moving and jumping
    - [x] Set the speed up 
    - [x] do keyboard based postion changes mul with dt for frame drops
- [x] Collision Classes
    - [x] Can create classes and then give them to collidor objects
    - [x] Objects Sleeping, physics engine stars working
        - [x] In the world put sleep param as false
    - [x] Can set rotation of objects with setFixedRotation
    - [x] When player enter a particular collision calss do something example die
- [x] Querying Collidor
    - [x] Query collidors and then perform a function
- [x] Animations
    - [x] Using sprites sheets
    - [x] [get anim8](https://github.com/kikito/anim8)
    - [x] Calculate how the grid works
        - [x] get the sheets dims 9210w * 1692h
        - [x] it has 15 Colums wide and 3 rows tall
        - [x] Divide the width and height with the dimensions = size of individual image
            - [x] 9210/15 = 614 width
            - [x] 1692/3 = 564 height
                - [x] put these in the newGrid
    - [x] Create animations table and put all the states 
        - [x] Can also define it's speed
- [x] Player Graphics
    - [x] Attaching the animation to the player collidor
    - [x] Calculate by taking the the individual picture and the finding the best ofset so that the collidor fits the sprites better
    - [x] Smaller items have lesser mass, thus for linear impulse might be required to be reduced, do not ploay around with grav during those times
- [x] Changing between Animations
    - [x] Create a flag to see if moving, its always false and even in update but changes when the button is pressed, and when pressed, player.animation = animations.run
- [] Player Direction
    - [] 