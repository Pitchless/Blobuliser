import hypermedia.video.*;
import java.awt.*;


OpenCV opencv;

int w = 640;
int h = 480;
int threshold = 40;
int numBlobs = 16;
boolean detectHoles = true;
int minBlobSize = 10;
float fadeDown = 0.8;   // Percent reduction per frame for ghost lines.
// Blur the shadow lines. e.g. 1 or 2. 0 disables. Slow!
float blurAmount = 0;
boolean showBlobs = false;
boolean showImage = true;
boolean showArtLayer = true;

PFont font;

boolean mirror = false;
color bgcol = color(0);
color fgcol = color(255, 255, 0);

PGraphics artLayer;

void setup() {
    size( w, h );

    opencv = new OpenCV( this );
    opencv.capture(width,height);
    
    font = loadFont( "AndaleMono.vlw" );
    textFont( font );

    println( "Drag mouse inside sketch window to change threshold" );
    println( "Press space bar to record background image" );
    
    background(bgcol);
    smooth();
    
    artLayer = createGraphics( width, height, P3D );
}



void draw() {

    //background(0);
    opencv.read();
    //opencv.invert();
    opencv.absDiff();               //  Calculates the absolute difference
    opencv.remember(); // diff image for next frame, track movement
    opencv.flip( OpenCV.FLIP_HORIZONTAL );

    opencv.convert( OpenCV.GRAY );  //  Converts the difference image to greyscale
    opencv.blur( OpenCV.BLUR, 3 );  //  I like to blur before taking the difference image to reduce camera noise

    if (showImage) {
      image( opencv.image(), 0, 0 );	            // RGB image
    }
    else {
      background(0);
    }

    // This will black and white the i,age
    opencv.threshold(threshold);

    //Blob[] blobs = opencv.blobs( 100, width*height/3, 20, true );
    Blob[] blobs = opencv.blobs( minBlobSize, width*height/3, numBlobs, detectHoles );
    
    if ( showBlobs ) drawCentroids(blobs);

    if ( blurAmount > 0 ) artLayer.filter( BLUR, blurAmount );
    artLayer.loadPixels();
    for ( int i=0; i<artLayer.pixels.length; i++ ) {
        // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
        float r = red(artLayer.pixels[i]);
        float g = green(artLayer.pixels[i]);
        float b = blue(artLayer.pixels[i]);
        float a = alpha(artLayer.pixels[i]);
        //colorMode( HSB, 1.0 );
        artLayer.pixels[i] = color( r * fadeDown, g * fadeDown, b * fadeDown, a * fadeDown );
        colorMode( RGB, 255 );
    }
    artLayer.updatePixels();
//    artLayer.tint(100);
//    artLayer.background(0,0,0,0);

    artLayer.beginDraw();
    //artLayer.fill( 0 );
    //artLayer.stroke( 0 );
    //artLayer.rect( 0, 0, width, height );
    //PImage artLayer.copy();
    //artLayer.tintColor = color(255,0,0);
    //artLayer.tint(255,128);
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
       
       artLayer.strokeWeight(3);
       artLayer.stroke(fgcol, 160);
       artLayer.line( blob1.x, blob1.y, blob2.x, blob2.y );
       artLayer.strokeWeight(1);
       artLayer.line( blob1.x, blob1.y, blob2.x, blob2.y );
       artLayer.stroke(fgcol);
       if (mirror) {
           artLayer.line( blob1.x, blob1.y,  width - blob2.x, height - blob2.y );
       }
    }
    artLayer.endDraw();
    //opencv.convert( OpenCV.RGB );
    //opencv.copy( artLayer );
    //opencv.blur( OpenCV.BLUR, 4 );
    //opencv.brightness( -20 );
    //PImage oldLayer = opencv.image();
    //image( oldLayer, 0, 0 );
    //image( opencv.image(), 0, 0 );
    //tint(255,128);
    //artLayer.tint(255,20);
    if (showArtLayer) image(artLayer, 0, 0);
}

void drawCentroids( Blob[] blobs ) {
    for( int i=0; i<blobs.length; i++ ) {
        Rectangle bounding_rect	= blobs[i].rectangle;
        float area = blobs[i].area;
        //float circumference = blobs[i].length;
        Point centroid = blobs[i].centroid;

        // Centroids        
        stroke(0,0,255);
        line( centroid.x-5, centroid.y, centroid.x+5, centroid.y );
        line( centroid.x, centroid.y-5, centroid.x, centroid.y+5 );
        noStroke();
        fill(0,0,255);
        text( area,centroid.x+5, centroid.y+5 );
        
        // rectangle and ellipse
        noFill();
        //stroke( blobs[i].isHole ? 128 : 64 );
        stroke(0,255,0);
        rect( bounding_rect.x, bounding_rect.y, bounding_rect.width, bounding_rect.height );
        ellipse( centroid.x, centroid.y, 20, 20 );   
    }
}

void mouseDragged() {
    threshold = int( map(mouseX,0,width,0,255) );
    println( "threshold:" + threshold );
}

public void stop() {
    opencv.stop();
    super.stop();
}

void mousePressed() {
    background(bgcol);
    artLayer.background(bgcol);
}

void keyPressed() {
  if (key == 'm') {
    mirror = !mirror;
  }
  else if (key == 'b') {
    blurAmount = blurAmount == 0 ? 1.0 : 0;
  }
  else if (key == 'F') {
    fgcol = color(255,255,0);
    stroke(fgcol);
  }
  else if (key == 'f') {
    fgcol = color(random(0,255),random(0,255),random(0,255));
    stroke(fgcol);
  }
  else if (key == 's') {
    saveFrame();
  }
  else if (key == 'p') {
    showBlobs = showBlobs ? false : true;
    background(0);
  }
  else if (key == 'i') {
    showImage = showImage ? false : true;
  }
  else if (key == 'r') {
    opencv.remember();
  }
  else if (key == 'h') {
    detectHoles = detectHoles ? false : true;
    println( "detectHoles:" + detectHoles );
  }
  else if (key == 'a') {
    showArtLayer = showArtLayer ? false : true;
    println( "showArtLayer:" + showArtLayer );
  }
}

