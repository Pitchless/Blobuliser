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
boolean ps3cam = false;

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

Layer[] layers;
Layer[] audioLayers;

Capture capture;
PImage captureImage; // Stash the image after capture
BackgroundGranulation gbGran;

PImage userImg;
PImage lastUserImg;
boolean soundFlipFlop;

ControlP5 ui;
Toggle uiBeRandom;

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

    println( "Drag mouse inside sketch window to change threshold" );
 
    // Create all the effect layers we will use   
    int j = 0;
    layers = new Layer[19];
    layers[j++] = new BlobTracker();
    layers[j++] = new Filler(1);
    layers[j++] = new BigRaver(true, 0.986);
    layers[j++] = new Filler2(1);
    layers[j++] = new Filler2(2);
    layers[j++] = new Shapes2(1,0.9999999); // square    
    layers[j++] = new Shapes2(2,0.9999999); // circle    
    layers[j++] = new Shapes2(1,0.998); // square
    layers[j++] = new Shapes2(2,0.996); // circle
    layers[j++] = new Shapes2(1,0.68); // square
    layers[j++] = new Shapes2(2,0.72); // circle
    layers[j++] = new Shapes(1,0.9); // square
    layers[j++] = new Shapes(2,0.8); // circle
    layers[j++] = new Shapes(1,0.1); // square
    layers[j++] = new Shapes(2,0.2); // circle
    layers[j++] = new CatsCradle();
    layers[j++] = new NextManLines();
    layers[j++] = new BigRaver();
    layers[j++] = new BigRaver(true);

    // and the audio layers
    j = 0;
    audioLayers = new Layer[2];
    audioLayers[j++] = new Noizer();
    audioLayers[j++] = new FModer();
    gbGran = new BackgroundGranulation();
    gbGran.setup();
    
    // Setup all the crap we created above
    println("Setting up layers");
    for ( int i=0; i<layers.length; i++ ) {
      layers[i].setup();
    }
    println("Setup " + layers.length + " video layers");
    for ( int i=0; i<audioLayers.length; i++ ) {
      audioLayers[i].setup();
    }
    println("Setup " + audioLayers.length + " audio layers");
    toggleRandomLayer();

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
        audioLayers[0].hide();
        audioLayers[1].hide();
  
        // turn on soundscape, set variable
        gbGran.setSamples();
        gbGran.show();
        interactif = false;
        println("Non - interactive mode!");
        timeSinceBlob = 0;
  
      }

      if(blobs.length > 0 && interactif == false) {
        // turn on both interactive noises
        if ( soundFlipFlop ) { audioLayers[0].show();audioLayers[1].hide(); } else { audioLayers[1].show(); audioLayers[0].hide();}
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
 
    // Draw all visible layers   
    for ( int i=0; i<layers.length; i++ ) {
      if ( layers[i].visible ) {
        layers[i].draw( blobs );
      }
    }
    
    // Draw all audio layers   
    for ( int i=0; i<audioLayers.length; i++ ) {
      if ( audioLayers[i].visible ) {
        audioLayers[i].draw( blobs );
      }
    }
    
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
}

public void stop() {
    opencv.stop();
    super.stop();
}

void toggleLayer( int layerOn ) {
  for ( int i=0; i<layers.length; i++ ) {
    Layer layer = layers[i];
    println("toggle layer:" + layerOn);
    if ( i==layerOn ) { layer.show(); } else { layer.hide(); } 
  }
}

int randomLayer() {
    int layerOn = (int)random( 1, layers.length );
    return layerOn;
}

void toggleRandomLayer() {
    toggleLayer( randomLayer() );
}

void setRandomLayers() {
  for ( int i=0; i<layers.length; i++ ) {
    layers[i].hide();
  }
  int numLayers = (int)random(1,3);
  println("num layers" + numLayers);
  for ( int i=0; i<numLayers; i++) {
    layers[randomLayer()].show(); 
  }
}

// Turn randomisation on and off keeping the UI in sync
void randomOff() {
    beRandom = false;
    uiBeRandom.changeValue(0.0);
    for ( int i=1; i<layers.length; i++ ) {
      layers[i].visible = false;
    }
}
void randomOn() {
    beRandom = true;
    uiBeRandom.changeValue(1.0);
    toggleRandomLayer();
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
    if ( i > layers.length ) {
      println("Layer " + i + " does not exist");
    }
    else {
      //layers[i-1].toggleVisible();
      if ( layers[i-1].visible ) { layers[i-1].hide(); } else { layers[i-1].show(); }
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
    audioLayers[0].show();
  }
  else if (key == 'N' ) {
    audioLayers[0].hide();
  }
  else if (key == 'm' ) {
    audioLayers[1].show();
  }
  else if (key == 'M' ) {
    audioLayers[1].hide();
  }
}

// Called from UI button
void uiBeRandom(boolean val) {
  if (val) { randomOn(); } else { randomOff(); }
}

