import hypermedia.video.*;
import java.awt.*;

// OpenCV instance
OpenCV opencv;

// threshold threshold
float threshold = 80f;

// image dimensions
final int IMG_WIDTH  = 800;
final int IMG_HEIGHT = 800;

// work with which color space
final int COLOR_SPACE = OpenCV.RGB;
//final int COLOR_SPACE = OpenCV.GRAY;

void setup() {

  size( IMG_WIDTH, IMG_HEIGHT );

  opencv = new OpenCV(this);
  opencv.capture(IMG_WIDTH, IMG_HEIGHT);

  println( "Drag mouse inside sketch window to change threshold" );
}



void draw() {

  float value = 0;
  float otsu  = 0;

  // grab image
  opencv.read();

    image( opencv.image(), 10, 10 );	            // RGB image
    image( opencv.image(OpenCV.GRAY), 20+width, 10 );   // GRAY image
    image( opencv.image(OpenCV.MEMORY), 10, 20+height ); // image in memory

    opencv.absDiff();
    opencv.threshold(threshold);
    image( opencv.image(OpenCV.GRAY), 20+width, 20+height ); // absolute difference image
  
  Blob[] blobs = opencv.blobs( 100, width*height/3, 20, true );

println blobs;

  noFill();

  pushMatrix();
  translate(20+width,20+height);
    
  for( int i=0; i<blobs.length; i++ ) {
        Rectangle bounding_rect	= blobs[i].rectangle;
        float area = blobs[i].area;
        float circumference = blobs[i].length;
        Point centroid = blobs[i].centroid;
        Point[] points = blobs[i].points;

        // rectangle
        noFill();
        stroke( blobs[i].isHole ? 128 : 64 );
        rect( bounding_rect.x, bounding_rect.y, bounding_rect.width, bounding_rect.height );
    }
    popMatrix();
}


void mouseDragged() {
  threshold = map(mouseX,0,width,0,255);
  println( "threshold\t-> "+threshold );
}

public void stop() {
  opencv.stop();
  super.stop();
}
