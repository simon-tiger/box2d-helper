import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// A reference to our box2d world
World world;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries = new ArrayList<Boundary>();
// A list for all of our rectangles
ArrayList<Box> boxes = new ArrayList<Box>();

void setup() {
  size(640,360);
  
  // Initialize box2d physics and create the world
  world = createWorld();
  
  // Add a bunch of fixed boundaries
  boundaries.add(new Boundary(width/4,height-5,width/2-50,10));
  boundaries.add(new Boundary(3*width/4,height-50,width/2-50,10));
  
  Box b = new Box(width/2,30);
  boxes.add(b);
}

void draw() {
  background(51);
  
  // We must always step through time!
  float timeStep = 1.0/30;
  // 2nd and 3rd arguments are velocity and position iterations
  world.step(timeStep,10,10);
  
  // Boxes fall from the top every so often
  if (random(1) < 0.2) {
    Box b = new Box(width/2,30);
    boxes.add(b);
  }
  
  // Display all boundaries
  for (Boundary b : boundaries) {
    b.display();
  }
  
  // Display all boxes
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    b.display();
    if (b.done()) {
      boxes.remove(i);
    }
  }
}