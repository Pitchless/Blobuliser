class NextManLines extends Layer {

  PGraphics img;
  
  void setup() {
    println("Hello setup");
    img = createGraphics( width, height, P3D );
  }
  
  Boolean draw( Blob blobs[] ) {
    // Fade down layer before drawing new frame
    img.loadPixels();
    for ( int i=0; i<img.pixels.length; i++ ) {
        // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
        float r = red(img.pixels[i]);
        float g = green(img.pixels[i]);
        float b = blue(img.pixels[i]);
        float a = alpha(img.pixels[i]);
        //colorMode( HSB, 1.0 );
        img.pixels[i] = color( r * fadeDown, g * fadeDown, b * fadeDown, a * fadeDown );
        colorMode( RGB, 255 );
    }
    img.updatePixels();
//    img.tint(100);
//    img.background(0,0,0,0);

    img.beginDraw();
    //img.fill( 0 );
    //img.stroke( 0 );
    //img.rect( 0, 0, width, height );
    //PImage img.copy();
    //img.tintColor = color(255,0,0);
    //img.tint(255,128);
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
       if (mirror) {
           img.line( blob1.x, blob1.y,  width - blob2.x, height - blob2.y );
       }
    }
    img.endDraw();
    image( img, 0, 0 );
    return true;
  }

}
