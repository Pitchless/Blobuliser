class Filler2 extends Layer {

  int       drawShape    = 1; // 1=square 2=circle
  Boolean   isCentered   = false;
  Float     fadePerFrame = 0.97;
  float     scaleRatio   = 0.7;
  float     rotation     = 0;

  Filler2() {}
  
  Filler2( int drawShape ) {
    this.drawShape = drawShape;
  }

  Filler2( int drawShape, float scaleRatio ) {
    this.drawShape = drawShape;
    this.scaleRatio = scaleRatio;
  }

  Filler2( int drawShape, float scaleRatio, float rotation ) {
    this.drawShape  = drawShape;
    this.scaleRatio = scaleRatio;
    this.rotation   = rotation;
  }
  
  void setup() {
    super.setup();
    img = createGraphics( width, height, P3D );
  }
  
  Boolean draw( Blob blobs[] ) {
    fade( fadePerFrame );
    cycleColor();

    img.beginDraw();
    img.rectMode(CENTER);
    img.ellipseMode(CENTER);
    //img.translate( width/2, height/2 );
    //img.rotate(PI/3.0);

    for( int i=0; i < blobs.length; i++ ) {
      Point blob = blobs[i].centroid;
      Rectangle bounding_rect = blobs[i].rectangle;
      color fillcol = color(red(fgcol),green(fgcol),blue(fgcol), 200);
      img.fill( fillcol );
      img.stroke( fillcol );
      //img.strokeWeight(2);
      img.translate( blob.x, blob.y );
      img.rotate( radians(rotation) );
      switch ( drawShape ) {
        case 1:
          img.rect( 0, 0, bounding_rect.width, bounding_rect.height );
          //img.rect( blob.x, blob.y, size, size );
        break;
        case 2:
          img.ellipse( 0, 0, bounding_rect.width, bounding_rect.height );
        break;
      }
    }
    img.endDraw();
    image( img, 0, 0 );
    return true;
  }

}
