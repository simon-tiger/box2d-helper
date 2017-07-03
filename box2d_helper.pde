
float lineWidth = 1;

void lineWidth(float n) {
  lineWidth = n;
  strokeWeight(n);
}

// ---------------------------------------------------------------------------
// Scale Methods
// ---------------------------------------------------------------------------

float scaleFactor;

Vec2 scaleToWorld(Vec2 a) {
  Vec2 newv = new Vec2();
  newv.x = (a.x)/scaleFactor;
  newv.y = (a.y)/scaleFactor;
  return newv;
}

Vec2 scaleToWorld(float a, float b) {
  Vec2 newv = new Vec2();
  newv.x = (a)/scaleFactor;
  newv.y = (b)/scaleFactor;
  return newv;
}

float scaleToWorld(float a) {
  return a/scaleFactor;
}

Vec2 scaleToPixels(Vec2 a) {
  Vec2 newv = new Vec2();
  newv.x = (a.x)*scaleFactor;
  newv.y = (a.y)*scaleFactor;
  return newv;
}

Vec2 scaleToPixels(float a, float b) {
  Vec2 newv = new Vec2();
  newv.x = (a)*scaleFactor;
  newv.y = (b)*scaleFactor;
  return newv;
}

float scaleToPixels(float a) {
  return a*scaleFactor;
}

// ---------------------------------------------------------------------------
// Create Methods
// ---------------------------------------------------------------------------

World createWorld() {
  
  Vec2 gravity = new Vec2(0,20);
  
  scaleFactor = 10;
  
  return new World(gravity);
}

// ---------------------------------------------------------------------------
// Draw Methods
// ---------------------------------------------------------------------------

void debugDraw(float scale, World world) {
  
  fill(#DDDDDD);
  noStroke();
  rect(0, 0, width, height);
  
  // Draw joints
  Joint j = world.getJointList();
  while (j.m_next != null) {
    lineWidth(0.25);
    stroke(#0000FF);
    drawJoint(scale, world, j);
    j = j.m_next;
  }
  
  // Draw body shapes
  Body b = world.getBodyList();
  while (b.m_next != null) {
    Fixture f = b.getFixtureList();
    while (f.getNext() != null) {
      lineWidth(0.5);
      stroke(#FF0000);
      
      f = f.getNext();
    }
    b = b.m_next;
  }
}

void drawJoint(float scale, World world, Joint joint) {
  
  pushStyle();
  pushMatrix();
  scale(scale,scale);
  lineWidth(lineWidth / scale);
  
  Body b1 = joint.getBodyA();
  Body b2 = joint.getBodyB();
  Vec2 x1 = b1.getPosition();
  Vec2 x2 = b2.getPosition();
  Vec2 p1 = null;
  Vec2 p2 = null;
  if (joint.getType() == JointType.DISTANCE) {
    p1 = ((DistanceJoint) joint).getLocalAnchorA();
    p2 = ((DistanceJoint) joint).getLocalAnchorB();
  }
  
  switch (joint.getType()) {
    case DISTANCE:
    case MOUSE:
      if (p1 != null && p2 != null) {
        line(p1.x, p1.y, p2.x, p2.y);
      }
      break;
    default: {
      noFill();
      beginShape();
      vertex(x1.x, x1.y);
      vertex(x2.x, x2.y);
      endShape();
    }
  }
  popMatrix();
  popStyle();
}

void drawShape(float scale, World world, Body body, Fixture fixture) {
  
  pushStyle();
  pushMatrix();
  scale(scale,scale);
  
  Vec2 bPos = body.getPosition();
  translate(bPos.x, bPos.y);
  rotate(body.getAngle());
  
  beginShape();
  lineWidth(lineWidth / scale);
  
  Shape shape = fixture.getShape();
  switch (shape.getType()) {
    case CIRCLE: {
      float r = shape.m_radius;
      
      ellipse(0, 0, r*2, r*2);
      line(0, 0, r, 0);
    } break;
    
    case POLYGON:
    case CHAIN: {
      
      Vec2[] vertices = {};
      int vertexCount = 0;
      
      if (shape.getType() == ShapeType.POLYGON) {
        PolygonShape ps = (PolygonShape) shape;
        vertices = ps.getVertices();
        vertexCount = ps.getVertexCount();
      } else if (shape.getType() == ShapeType.CHAIN) {
        ChainShape cs = (ChainShape) shape;
        vertices = cs.m_vertices;
        vertexCount = cs.m_count;
      }
      if (vertexCount == 0) return;
      
      for (int i = 0; i < vertexCount; i++) {
        vertex(vertices[i].x, vertices[i].y);
      }
    } break;
  }
  endShape();
  popMatrix();
  popStyle();
}