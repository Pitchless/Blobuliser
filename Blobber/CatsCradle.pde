class CatsCradle extends ImgLayer {
  
  CatsCradle() { randomise(); }
  
  void draw( Blob blobs[] ) { 
    img.beginDraw();
    img.background(0,0,0,0);

    for( int i=0; i < blobs.length; i++ ) {
      Point blob = blobs[i].centroid;
      for( int j=0; j<blobs.length; j++ ) {
        Point blob2 = blobs[j].centroid;
        colorMode(HSB);
        color linecol = color( hue(fgcol), 255, 255, 100 );
        colorMode(RGB);
        img.stroke(linecol);
        img.strokeWeight(1);
        img.line( blob.x, blob.y, blob2.x, blob2.y );
      }
    }
    img.endDraw();
    super.draw(blobs);
  }

}
