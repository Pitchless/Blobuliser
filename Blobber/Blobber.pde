import hypermedia.video.*;
import java.awt.*;
import processing.video.*; 


OpenCV opencv;

int w = 640;
int h = 480;
boolean ps3cam = true;
int threshold = 40;
int numBlobs = 16;
boolean detectHoles = true;
int minBlobSize = 10;
float fadeDown = 0.8;   // Percent reduction per frame for ghost lines.
// Blur the image 1 or 2. 0 disables. Slow!
float blurAmount = 0;
boolean showBlobs = false;
boolean showImage = true;

PFont font;

boolean mirror = false;
color bgcol = color(0);
color fgcol = color(255, 255, 0);

Layer[] layers;

Capture capture;

void setup() {
    size( w, h );

    // List cameras
    String[] devices = Capture.list();
    println(devices);

    opencv = new OpenCV( this );
    // Is still useful with ps3 i think it sets up the buffer size?
    opencv.capture(width,height);
    
    font = loadFont( "AndaleMono.vlw" );
    textFont( font );

    println( "Drag mouse inside sketch window to change threshold" );
    
    background(bgcol);
    smooth();
        
    layers = new Layer[7];
    layers[0] = new BlobTracker();
    layers[4] = new Squares();
    layers[1] = new NextManLines();
    layers[2] = new BigRaver();
    layers[3] = new BigRaver(true);
    layers[5] = new CatsCradle();
    layers[6] = new Noizer();

    println("Setting up layers");
    for ( int i=0; i<layers.length; i++ ) {
      layers[i].setup();
    }
    println("Setup " + layers.length + " layers");

    if ( ps3cam ) {
      capture = new Capture( this, width, height, 30 );
      capture.settings();
    }
}



void draw() {
    //background(0);

    if ( ps3cam ) {
      if ( !capture.available() ) {
        println( "No capture" );
        return;  // no point rendering without a frame!
      };
      capture.read();
      opencv.copy( capture );
    }
    else {
      opencv.read();
    }
    //opencv.flip( OpenCV.FLIP_HORIZONTAL );
    PImage rememberImage = opencv.image(); // Will use after absDiff to set image for diff next frame
   
    //opencv.invert();
    opencv.absDiff();               // Calculates the absolute difference
    opencv.convert( OpenCV.GRAY );  // Converts the difference image to greyscale
    opencv.blur( OpenCV.BLUR, 3 );  // I like to blur before taking the difference image to reduce camera noise

    // The ghost users
    if (showImage) {
      image( opencv.image(), 0, 0 );
    }
    else {
      background(0);
    }
 
    // This will black and white the i,age
    opencv.threshold(threshold);

    //Blob[] blobs = opencv.blobs( 100, width*height/3, 20, true );
    Blob[] blobs = opencv.blobs( minBlobSize, width*height/3, numBlobs, detectHoles );
 
    // Draw all visible layers   
    for ( int i=0; i<layers.length; i++ ) {
      if ( layers[i].visible ) {
        layers[i].draw( blobs );
      }
    }

    if ( blurAmount > 0 ) filter( BLUR, blurAmount );

    // Remember the image to use for the next absDiff
    opencv.copy( rememberImage );
    opencv.remember(1);

}

public void stop() {
    opencv.stop();
    super.stop();
}

void mouseDragged() {
    threshold = int( map(mouseX,0,width,0,255) );
    println( "threshold:" + threshold );
}

void mousePressed() {
    background(bgcol);
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
  else if (key == '1' ) {
    showImage = showImage ? false : true;
  }
  else if ( key > 49 && key < 61 ) { // keys '2' - '0'
    int i = key;
    i -= 49;
    //i += 1;
    println( "Toggle layer " + i );
    if ( i > layers.length ) {
      println("Layer " + i + " does not exist");
    }
    else {
      layers[i-1].toggleVisible();
      background(0);
    }
  }
  else if (key == 'r') {
    opencv.remember();
  }
  else if (key == 'h') {
    detectHoles = detectHoles ? false : true;
    println( "detectHoles:" + detectHoles );
  }
}

