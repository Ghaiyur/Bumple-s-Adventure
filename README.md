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
- [x] Player Direction
    - [x] change x scale factor to negative to flip
    - [x] Multiple the xscale with the 1 or -1 to decide when to flip, 1 is right direction
- [x] Jump Animation
    - [x] Check in update if the platform collidors right below player, if its more than 0 , keep the grounded flag as true or else false
- [x] Multi File Programs
    - [x] Create a module out of players, needs require
- [x] Tiled
    - [x] [Map Editor](https://www.mapeditor.org)
    - [x] Default love2d window 800x600
        - [x] love.window.setMode
        - [x] use tiled to create the full level
- [x] Import as lua, export
    - [x] [Simpled tiled implementation](https://github.com/karai17/Simple-Tiled-Implementation)
    - [x] Import it in
    - [x] Import into main
        - [x] First make an extra function called loadMap
        - [x] then update it using gameMap and tell it which time layer to use
        - [x] In draw gameMap:drawLayer(gameMap.layers['Tile Layer 1'])
        - [x] in load just call the misc function loadmap
- [x] Collidor object from Tiled
    - [x] In tiled first create an object layer for each objects
    - [x] Create a new misc function and input the collidor maker and make them insert in the platforms group
    - [x] ```for i,obj in pairs(gameMap.layers['Platforms'].objects) do
        spawnPlatform(obj.x,obj.y,obj.width,obj.height)     ```
        - [x] get the objects from the Platforms
        - [x] Create platform collidors on the same places
- [x] Camera
    - [x] [Camera tools](https://github.com/vrld/hump)
        - [x] First import it with require
        - [x] Make a object out of the fuction call 
        - [x] Update it to look at player pos
        - [x] make it draw over everything by using attach and detach
- [x] Platformer Enemies
    - [x] Sort of similar to player movement but much more automated and just capable of left and right, has query collidors when found none, *-1 into direction
    - [x] be careful with variable naming as always
    - [x] Two types of function calls one with dots and one with colons, be careful
    - [x] sprites direction is handy
    - [x] enemies can be created as object layer in tiled
        - [x] ```for i,obj in pairs(gameMap.layers['Enemies'].objects) do
        spawnEnemies(obj.x,obj.y)
    end``` Similar to tile object, very nice loop that creates sprited colidors 
- [x] Level Transition
    - [x] Created Level 2 
    - [x] Create flag tileset and object layer
    - [x] Created Forwardmoving levels
- [x] Saving Progress
    - [x] Created counter of level progress triggered by flag picks 
    - [x] using show.lua, save it in local cache
- [x] Music and sounds
    - [x] added jump and some music
- [] Finishing touches
    - [x] BG
    - [] Hud
    - [] Danger zone
    - [] Player respawn point , created a object layer in tiled
