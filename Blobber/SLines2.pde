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
      Arrays.sort(sortedBlobs, XSort);
      int len = blobs.length % 2 == 0 ? blobs.length : blobs.length -1;
      int half = len / 2;
      Blob lefts[]  = new Blob[half];
      Blob rights[] = new Blob[half];
      for (int i=0; i<half; i++) {
        lefts[i]  = sortedBlobs[i];
        rights[i] = sortedBlobs[i+half];
      }
      Arrays.sort(lefts, YSort);
      Arrays.sort(rights, YSort);
      drawJoinedBlobs(lefts, rights);
    }
    if ((direction & VERT)==VERT) {
      Arrays.sort(sortedBlobs, YSort);
      int len = blobs.length % 2 == 0 ? blobs.length : blobs.length -1;
      int half = len / 2;
      Blob tops[]    = new Blob[half];
      Blob bottoms[] = new Blob[half];
      for (int i=0; i<half; i++) {
        tops[i]    = sortedBlobs[i];
        bottoms[i] = sortedBlobs[i+half];
      }
      Arrays.sort(tops, XSort);
      Arrays.sort(bottoms, XSort);
      drawJoinedBlobs(tops, bottoms);
    }
    img.endDraw();
    image( img, 0, 0 );
    return true;
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
