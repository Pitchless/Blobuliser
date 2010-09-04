/*
 * Horizontal or Vertical Lines Layer
 */
class SLines extends Layer {

  int direction = 1; // 1=horizontal 2=vertical
  
  Comparator XSort = new Comparator() {
      int compare(Object oa, Object ob) {
        Point a = ((Blob)oa).centroid;
        Point b = ((Blob)ob).centroid;
        if (a.x == b.x) return 0;
        return a.x < b.x ? -1 : 1;
      }
  };

  Comparator YSort = new Comparator() {
      int compare(Object oa, Object ob) {
        Point a = ((Blob)oa).centroid;
        Point b = ((Blob)ob).centroid;
        if (a.y == b.y) return 0;
        return a.y < b.y ? -1 : 1;
      }
  };
  
  SLines(int direction) {
    this.direction = direction;
  }
  
  void setup() {
    super.setup();
    img = createGraphics( width, height, P3D );
  }
  
  Boolean draw( Blob blobs[] ) {
    fade(0.9);
    cycleColor();
    
    Blob xblobs[] = (Blob[])blobs.clone(); // shallow copy
    Arrays.sort(xblobs, direction == 1 ? YSort : XSort);

    img.beginDraw();
    int len = xblobs.length % 2 == 0 ? xblobs.length : xblobs.length -1;
    for( int i=0; i<len; i+=2 ) {
       Point blob1 = xblobs[i].centroid;
       Point blob2 = xblobs[i+1].centroid;
       
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
