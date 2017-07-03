// A rectangular box

class Box {
  float w = random(4, 16);
  float h = random(4, 16);
  
  Body body;
  
  Box(float x, float y) {
    
    // Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position = scaleToWorld(x,y);
    
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    // Fixture holds shape
    PolygonShape shape = new PolygonShape();
    shape.setAsBox(scaleToWorld(w/2), scaleToWorld(h/2));
    fd.shape = shape;
    
    // Some physics
    fd.density = 1.0;
    fd.friction = 0.5;
    fd.restitution = 0.2;
    
    // Create the body
    body = world.createBody(bd);
    // Attach the fixture
    body.createFixture(fd);
    
    // Some additional stuff
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5,5));
  }
  
  // This function removes the particle from the box2d world
  void killBody() {
    world.destroyBody(body);
  }
  
  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = scaleToPixels(body.getPosition());
    // Is it off the bottom off the screen?
    if (pos.y > height+w*h) {
      killBody();
      return true;
    }
    return false;
  }
  
  // Drawing the box
  void display() {
    // Get the body's position
    Vec2 pos = scaleToPixels(body.getPosition());
    // Get its angle of rotation
    float a = body.getAngle();
    
    // Draw it!
    rectMode(CENTER);
    pushStyle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(127);
    stroke(200);
    strokeWeight(2);
    rect(0, 0, w, h);
    popMatrix();
    popStyle();
  }
}