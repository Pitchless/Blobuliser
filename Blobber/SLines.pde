/*
 * Horizontal or Vertical Lines Layer
 */
class SLines extends Layer {

  static final int HORI = 1;
  static final int VERT = 2;

  int direction = HORI;
  
  // Should be static but due to some Java inner class oddness it cant be
  Comparator XSort = new Comparator() {
      int compare(Object oa, Object ob) {
        Point a = ((Blob)oa).centroid;
        Point b = ((Blob)ob).centroid;
        if (a.x == b.x) return 0;
        return a.x < b.x ? -1 : 1;
      }
  };

  // Should be static but due to some Java inner class oddness it cant be
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
    // shallow copy so we don't effact the order for other layers
    Blob sortedBlobs[] = (Blob[])blobs.clone();

    img.beginDraw();
    if ((direction & HORI)==HORI) {
      Arrays.sort(sortedBlobs, YSort);  // Yes, Horizontal is a y sort, think about it ;-)
      drawLines(sortedBlobs);
    }
    if ((direction & VERT)==VERT) {
      Arrays.sort(sortedBlobs, XSort);
      drawLines(sortedBlobs);
    }
    img.endDraw();
    image( img, 0, 0 );
    return true;
  }

  void drawLines(Blob blobs[]) {
      int len = blobs.length % 2 == 0 ? blobs.length : blobs.length -1;
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
  }

}
