class NextManLines extends Layer {
  
  void setup() {
    super.setup();
    img = createGraphics( width, height, P3D );
  }
  
  Boolean draw( Blob blobs[] ) {
    fade(0.8);
    cycleColor();

    img.beginDraw();
    int len;
    if ( blobs.length % 2 == 0 ) {
      len = blobs.length;
    }
    else {
      len = blobs.length - 1;
    }
    for( int i=0; i<len; i+=2 ) {
       Point blob1 = blobs[i].centroid;
       Point blob2 = blobs[i+1].centroid;
       
       img.strokeWeight(3);
       img.stroke(fgcol, 160);
       img.line( blob1.x, blob1.y, blob2.x, blob2.y );
       img.strokeWeight(1);
       img.line( blob1.x, blob1.y, blob2.x, blob2.y );
       img.stroke(fgcol);
    }
    img.endDraw();
    image( img, 0, 0 );
    return true;
  }

}
