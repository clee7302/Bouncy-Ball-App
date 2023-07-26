import Foundation
//declare ball
let ball = OvalShape(width: 40, height: 40)

//declare a new variable to store the array
var barrier: [Shape] = []

var barriers: [Shape] = []

var targets: [Shape] = []
    

//declared funnel
let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]

let funnel = PolygonShape(points: funnelPoints)

/*
The setup() function is called once when the app launches. Without it, your app won't compile.
Use it to set up and start your app.

You can create as many other functions as you want, and declare variables and constants,
at the top level of the file (outside any function). You can't write any other kind of code,
for example if statements and for loops, at the top level; they have to be written inside
of a function.
*/



fileprivate func setUpBall() {
    ball.position = Point(x: 250, y: 400)
    scene.add(ball)
    ball.hasPhysics = true
    ball.fillColor = .blue
    ball.onCollision = ballCollided(with:)
    ball.isDraggable = false
    ball.bounciness = 0.6
    
    //to keep track of the ball's location and set the callback on the ball.
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
    
    ball.onTapped = resetGame
}

fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]

    let barrier = PolygonShape(points: barrierPoints)

    barriers.append(barrier)
    // Existing code from setupBarrier() below
    
    barrier.position = Point(x: 208.6665496826172, y: 213.99969482421875)
    
    barrier.hasPhysics = true
    scene.add(barrier)
    barrier.isImmobile = true
    barrier.fillColor = .brown
    barrier.angle = angle
}

fileprivate func setUpFunnel() {
    funnel.position = Point(x: 200, y: scene.height - 25)
    scene.add(funnel)
    funnel.onTapped = dropBall
    funnel.fillColor = .gray
    funnel.isDraggable = false
}

func addTarget(at position: Point)
{
    let targetPoints = [
            Point(x: 10, y: 0),
            Point(x: 0, y: 10),
            Point(x: 10, y: 20),
            Point(x: 20, y: 10)
        ]

        let target = PolygonShape(points: targetPoints)

        targets.append(target)

        // Existing code from setupTarget() below.
    
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    target.name = "target"
    scene.add(target)
    target.isDraggable = false
}

func setup() {
    // Add a ball to the scene.
    setUpBall()
    
    // Add a barrier to the scene.
    addBarrier(at: Point(x: 218.6, y: 345.3), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 69.6, y: 85.3), width: 20, height: 25, angle: -0.4)
    addBarrier(at: Point(x: 235.9, y: 35.3), width: 60, height: 25, angle: -0.2)
    addBarrier(at: Point(x: 208.6, y: 213.9), width: 50, height: 25, angle: 0.3)
    
    //208.6665496826172, 213.99969482421875
    //barrier positions for challenge (218.6654510498047, 345.3291015625)
    //(69.66619110107422, 85.33300018310547)
    //(235.9983673095703, 35.332786560058594)
    
    
    // Add a funnel to the scene.
    setUpFunnel()

    // Add a target to the scene.
    addTarget(at: Point(x: 100, y: 200))
    addTarget(at: Point(x: 150, y: 100))
    addTarget(at: Point(x: 120, y: 300))
    
    resetGame()
    
    scene.onShapeMoved = printPosition(of:)
}

func dropBall() {
    //reset the target to yellow before repositioning the ball (dropping).
    //target.fillColor = .yellow
    
    //simulate a ball dropping from the funnel when it is tapped.
    //we do this by assigning the value of the funnels position to the position of the ball.
    ball.position = funnel.position
    
    //used to cease momentum in the moving ball
    ball.stopAllMotion()
    
    for barrier in barriers {
        barrier.isDraggable = false
    }
    
    for target in targets {
        target.fillColor = .yellow
    }
}

// Handles collisions between the ball and the targets.
func ballCollided(with otherShape: Shape) {
    if otherShape.name != "target" { return }
    
    otherShape.fillColor = .green
}

//callback for when the ball exist screen.

func ballExitedScene () {
    for barrier in barriers {
        barrier.isDraggable = true
    }
    
    var hitTargets = 0
    for target in targets {
        if target.fillColor == .green {
            hitTargets += 1
        }
        
        if hitTargets == targets.count {
            print ("Won game!")
            scene.presentAlert(text: "You won!", completion: alertDismissed)
        }
        
    }
    
}


func alertDismissed() {
}

// Resets the game by moving the ball below the scene,
// which will unlock the barriers.
func resetGame() {
    ball.position = Point(x: 0, y: -80)
}


func printPosition(of shape: Shape) {
    print(shape.position)
}
