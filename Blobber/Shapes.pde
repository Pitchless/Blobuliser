class Shapes extends ImgLayer {

  int       drawShape    = 1; // 1=square 2=circle
  Boolean   isCentered   = false;
  float     fadePerFrame = 0.90;
  float     scaleRatio   = 0.7;
  float     rotation     = 0;

  Shapes() {}
  
  Shapes( int drawShape ) {
    this.drawShape = drawShape;
    this.fadePerFrame = 0.90;
  }

  Shapes( int drawShape, float scaleRatio ) {
    this.drawShape = drawShape;
    this.scaleRatio = scaleRatio;
    this.fadePerFrame = 0.90;
  }
  
  void draw( Blob blobs[] ) {
    fade();
    cycleColor();

    img.beginDraw();
    img.rectMode(CENTER);
    img.ellipseMode(CENTER);

    for( int i=0; i < blobs.length; i++ ) {
      Point blob = blobs[i].centroid;
      float size = blobs[i].area * scaleRatio;
      img.noFill();
      img.stroke( fgcol );
      img.strokeWeight(2);
      switch ( drawShape ) {
        case 1:
          img.rect( blob.x, blob.y, size, size );
        break;
        case 2:
          img.ellipse( blob.x, blob.y, size, size );
        break;
      }
    }
    img.endDraw();
    super.draw(blobs);
  }

}
