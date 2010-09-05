/**
 * Layer to display info on the blobs detected.
 */
class BlobTracker extends Layer {

  void draw( Blob[] blobs ) {
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
      stroke( blobs[i].isHole ? color(#FFFF00) : color(#00FF00) );
      rect( bounding_rect.x, bounding_rect.y, bounding_rect.width, bounding_rect.height );
      ellipse( centroid.x, centroid.y, 20, 20 );   
    }
  }

}
