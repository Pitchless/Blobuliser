/*
 * Horizontal or Vertical Lines Layer 2
 * Updated to also sort other way when drawing to get straighter lines.
 */
class SLines2 extends Layer {

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
  
  SLines2(int direction) {
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
        Blob splitBlobs[][] = splitSort(sortedBlobs, XSort, YSort);
        drawJoinedBlobs(splitBlobs[0], splitBlobs[1]);
    }
    if ((direction & VERT)==VERT) {
      Blob splitBlobs[][] = splitSort(sortedBlobs, YSort, XSort);
      drawJoinedBlobs(splitBlobs[0], splitBlobs[1]);
    }
    img.endDraw();
    image( img, 0, 0 );
    return true;
  }

  // Given an array of blobs, sorts that array and then splits into 2 halfs and sort those halfs.
  // Returns 2 element array containing the arrays for each half.
  // e.g. Blob splitBlobs[][] = splitSort(blobs, XSort, YSort);
  // Sort all the blobs based on x (left to right) then split (left side blobs and right side blobs),
  // then sort those blobs on y (top to bottom).
  Blob[][] splitSort(Blob blobs[], Comparator sort1, Comparator sort2) {
    Arrays.sort(blobs, sort1);
    int len = blobs.length % 2 == 0 ? blobs.length : blobs.length -1;
    int half = len / 2;
    Blob blobs1[] = new Blob[half];
    Blob blobs2[] = new Blob[half];
    for (int i=0; i<half; i++) {
      blobs1[i] = blobs[i];
      blobs2[i] = blobs[i+half];
    }
    Arrays.sort(blobs1, sort2);
    Arrays.sort(blobs2, sort2);
    Blob out[][] = new Blob[2][];
    out[0] = blobs1;
    out[1] = blobs2;
    return out;
  }

  void drawJoinedBlobs(Blob b1[], Blob b2[]) {
    for(int i=0; i<b1.length; i++) {
         Point p1 = b1[i].centroid;
         Point p2 = b2[i].centroid;
         img.strokeWeight(3);
         img.stroke(fgcol, 160);
         img.line( p1.x, p1.y, p2.x, p2.y );
         img.strokeWeight(1);
         img.stroke(fgcol);    
         img.line( p1.x, p1.y, p2.x, p2.y );
    }
  }

}
