// A fixed boundary class

// A boundary is a simple rectangle with x,y,width,and height
class Boundary {
  // But we also have to make a body for box2d to know about it
  Body body;
  
  float x;
  float y;
  float w;
  float h;
  
  Boundary(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    
    FixtureDef fd = new FixtureDef();
    fd.density = 1.0;
    fd.friction = 0.5;
    fd.restitution = 0.2;
    
    BodyDef bd = new BodyDef();
    
    bd.type = BodyType.STATIC;
    bd.position.x = scaleToWorld(x);
    bd.position.y = scaleToWorld(y);
    PolygonShape shape = new PolygonShape();
    shape.setAsBox(w/(scaleFactor*2), h/(scaleFactor*2));
    fd.shape = shape;
    body = world.createBody(bd);
    body.createFixture(fd);
  }
  
  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    fill(127);
    stroke(0);
    rectMode(CENTER);
    rect(x,y,w,h);
  };
}