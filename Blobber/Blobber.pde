import hypermedia.video.*;
import java.awt.*;
import processing.video.*; 
import controlP5.*;

/*
 * Config - Tweaks these
 */

// Sketch size
int w = 640;
int h = 480;

// Some cams give mirror image
boolean flipCam = true;
// Use ps3 eye cam hack, read via processing and pass to opencv
boolean ps3cam = true;

// OpenCV blob detection settings
int threshold = 60;
int numBlobs = 16;
boolean detectHoles = true;
int minBlobSize = 10;

// Percent reduction per frame for ghost lines.
float fadeDown = 0.8;

// Blur the image, should be odd int. Broken! black and whites the image
int blurAmount = 0;

boolean showBlobs = false;

boolean showImage = true;

// Randomisation control
boolean beRandom = true;
int framesUntilChange = 30;
int frameChangeCounter = 0;
int timeSinceBlob =0 , delayForSound=50;
boolean interactif = false;


/*
 * Sketch globals - don't touch!
 */

OpenCV opencv;

Group layers      = new Group();
Group audioLayers = new Group();

Capture capture;
PImage captureImage; // Stash the image after capture
BackgroundGranulation gbGran;

PImage userImg;
PImage lastUserImg;
boolean soundFlipFlop;

ControlP5 ui;
Toggle uiBeRandom;
Toggle uiShowTracking;
Textfield uiFrameRate;

void setup() {
    size( w, h );
    background(0);
    smooth();
    frameRate(30);
    
    // List cameras
    String[] devices = Capture.list();
    println(devices);

    opencv = new OpenCV( this );
    opencv.capture(width,height); // Is still useful with ps3 i think it sets up the buffer size?
    lastUserImg = opencv.image();
       
    PFont font = loadFont( "AndaleMono.vlw" );
    textFont( font );
 
    // Create all the effect layers we will use   
    layers.add( new BlobTracker() );
    layers.add( new SLines2(SLines2.HORI) );
    layers.add( new SLines2(SLines2.VERT) );
    layers.add( new SLines2(SLines2.HORI|SLines2.VERT) ); // Both
    layers.add( new SLines(SLines.HORI) );
    layers.add( new SLines(SLines.VERT) );
    layers.add( new SLines(SLines.HORI|SLines.VERT) );  // Both. Nice :)
    layers.add( new BigRaver(true, 0.986) );
    layers.add( new Shapes2(1,0.9999999) ); // square
    layers.add( new Shapes2(2,0.9999999) ); // circle
    layers.add( new Shapes2(1,0.998) );     // square
    layers.add( new Shapes2(2,0.996) );     // circle
    layers.add( new Shapes2(1,0.68) );      // square
    layers.add( new Shapes2(2,0.72) );      // circle
    layers.add( new Shapes(1,0.9) );        // square
    layers.add( new Shapes(2,0.8) );        // circle
    layers.add( new Shapes(1,0.1) );        // square
    layers.add( new Shapes(2,0.2) );        // circle
    layers.add( new CatsCradle() );
    layers.add( new NextManLines() );
    layers.add( new BigRaver() );
    layers.add( new BigRaver(true) );
    layers.show();

    // and the audio layers
    audioLayers.add( new Noizer() );
    audioLayers.add( new FModer() );
    audioLayers.show();
    gbGran = new BackgroundGranulation();
    gbGran.setup();
    
    // Setup all the crap we created above
    println("Setting up layers");
    layers.setup();
    toggleRandomLayer();
    audioLayers.setup();
    println("Setup " + layers.size() + " video layers");
    println("Setup " + audioLayers.size() + " audio layers");
    
    if ( ps3cam ) {
      capture = new Capture( this, width, height, 30 );
      //capture.settings();
    }
    
    // Setup the UI
    ui = new ControlP5(this);
    ui.setColorForeground(color(170,170,0));
    ui.setColorBackground(color(80,80,80));
    ui.setColorActive(color(255,255,0));
    ui.setColorValue(color(0));
    // Note name auto binds to var of same name.
    // Wierd: Sliders get label on side but toggle goes underneath
    ui.addSlider("threshold",0,200,10,height-90,100,14);
    ui.addSlider("numBlobs",1,100,10,height-70,100,14);
    ui.addSlider("minBlobSize",0,100,10,height-50,100,14);
    ui.addToggle("detectHoles",10,height-30,14,14);
    uiBeRandom = ui.addToggle("uiBeRandom",true,80,height-30,14,14); // Bound to meth below.
    uiShowTracking = ui.addToggle("uiShowTracking",false,150,height-30,14,14); // Bound to meth below.
    uiFrameRate = ui.addTextfield("FPS",width-60,height-30,50,14);
}


void draw() {
    // Grab the camera image
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
    PImage captureImage = opencv.image(); // Will use after absDiff to set image for diff next frame

    //opencv.invert();
    opencv.blur( OpenCV.BLUR, 3 );  // I like to blur before taking the difference image to reduce camera noise
    opencv.absDiff();               // Calculates the absolute difference
    if (!ps3cam) opencv.remember();
    if (flipCam) opencv.flip( OpenCV.FLIP_HORIZONTAL );

    opencv.convert( OpenCV.GRAY );  // Converts the difference image to greyscale

    PImage ghostImage = opencv.image();
    
    // This will black and white the image
    opencv.threshold(threshold);
    
    //Blob[] blobs = opencv.blobs( 100, width*height/3, 20, true );
    Blob[] blobs = opencv.blobs( minBlobSize, width*height/3, numBlobs, detectHoles );
    
    // The ghost users
    if (showImage) {
      opencv.copy( lastUserImg );
      //opencv.blur( OpenCV.BLUR, 3 );
      opencv.brightness( 100 );
      opencv.contrast( 80);
      image( opencv.image(), 0, 0 );
      image( ghostImage, 0, 0 );
      lastUserImg = ghostImage;
    }
    else {
      background(0);
    }
 
    if ( beRandom) {
      // Dave's sound state changer
      if(blobs.length < 5 && interactif == true){
        timeSinceBlob ++;
      }
  
      // check if we had no blobz, turn annoying noisez off and 
      if(timeSinceBlob == delayForSound){
        // turn off both interactive noises
        audioLayers.hideAll();
  
        // turn on soundscape, set variable
        gbGran.setSamples();
        gbGran.show();
        interactif = false;
        println("Non - interactive mode!");
        timeSinceBlob = 0;
      }

      if(blobs.length > 0 && interactif == false) {
        // turn on both interactive noises
        if ( soundFlipFlop ) {
          audioLayers.get(0).show();
          audioLayers.get(1).hide();
        } else {
          audioLayers.get(1).show();
          audioLayers.get(0).hide();
        }
        soundFlipFlop = !soundFlipFlop;
  
        // turn off soundscape, set variable
        gbGran.hide();
        interactif = true;
        println("Interactive mode!");
      }
        
      frameChangeCounter++;
      if ( frameChangeCounter >= framesUntilChange ) {
        frameChangeCounter = 0;
        framesUntilChange = 10 + floor(random(0,81));
        //toggleRandomLayer();
        setRandomLayers();  
      }
    }
 
    // Draw layers   
    layers.draw( blobs );
    audioLayers.draw( blobs );    
    gbGran.draw(blobs);
    
    if ( blurAmount > 0 ) {
      opencv.copy(this.get());
      //opencv.convert( OpenCV.RGB );
      opencv.blur( OpenCV.BLUR, 3 );
      image( opencv.image(), 0, 0 );
      //filter( BLUR, blurAmount );
    }

    // Remember the image to use for the next absDiff
    if (ps3cam) {
      opencv.copy( captureImage );
      opencv.remember(1);
    }

    // Per frame UI updates if the ui is showing
    if (ui.isVisible()) {
      uiFrameRate.setText(str(frameRate));
    }
}

public void stop() {
    opencv.stop();
    super.stop();
}

int randomLayer() {
    int layerOn = (int)random( 1, layers.size() );
    return layerOn;
}

void toggleRandomLayer() {
    layers.toggle( randomLayer() );
}

void setRandomLayers() {
  layers.hideAll();
  int numLayers = (int)random(1,3);
  println("num layers" + numLayers);
  for ( int i=0; i<numLayers; i++) {
    layers.get(randomLayer()).show();
  }
}

// Turn randomisation on and off keeping the UI in sync
void randomOff() {
    beRandom = false;
    uiBeRandom.changeValue(0.0);
    layers.hideAll();
}
void randomOn() {
    beRandom = true;
    uiBeRandom.changeValue(1.0);
    toggleRandomLayer();
}

// Turn tracking layer on and off keeping the UI in sync
void showTracking() {
    uiShowTracking.changeValue(1.0);
    layers.get(0).show();
}
void hideTracking() {
    uiShowTracking.changeValue(0.0);
    layers.get(0).hide();
}

void keyPressed() {
  // Hide/Show UI and cursor with tab key
  if ( key == '\t' ) {
    if ( ui.isVisible() ) { 
      ui.hide();
      noCursor(); 
    } 
    else { 
      ui.show();
      cursor();
    } 
  }
  else if (key == 'b') {
    blurAmount = blurAmount == 0 ? 1 : 0;
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
    if ( i > layers.size() ) {
      println("Layer " + i + " does not exist");
    }
    else {
      layers.toggle( i-1 );
      background(0);
    }
  }
  else if (key == 'r') {
    randomOn();
  }
  else if (key == 'R') {
    randomOff();
  }
  else if (key == 'n' ) {
    audioLayers.get(0).show();
  }
  else if (key == 'N' ) {
    audioLayers.get(0).hide();
  }
  else if (key == 'm' ) {
    audioLayers.get(1).show();
  }
  else if (key == 'M' ) {
    audioLayers.get(1).hide();
  }
}

// Called from UI button
void uiBeRandom(boolean val) {
  if (val) { randomOn(); } else { randomOff(); }
}

// Called from UI button
void uiShowTracking(boolean val) {
  if (val) { showTracking(); } else { hideTracking(); }
}

