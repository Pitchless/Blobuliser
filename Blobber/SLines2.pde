/*
 * Horizontal or Vertical Lines Layer 2
 * Updated to also sort other way when drawing to get straighter lines.
 */
class SLines2 extends ImgLayer {

  static final int HORI = 1;
  static final int VERT = 2;

  int direction = HORI;
  
  SLines2() {
    this.fadePerFrame = 0.9;
  }
  
  SLines2(int direction) {
    this.direction = direction;
    this.fadePerFrame = 0.9;
  }
  
  void draw( Blob blobs[] ) {
    fade();
    cycleColor();
    // shallow copy so we don't effact the order for other layers
    Blob sortedBlobs[] = (Blob[])blobs.clone();

    img.beginDraw();
    if ((direction & HORI)==HORI) {
        Blob splitBlobs[][] = splitSort(sortedBlobs, BlobSort.X, BlobSort.Y);
        drawJoinedBlobs(splitBlobs[0], splitBlobs[1]);
    }
    if ((direction & VERT)==VERT) {
      Blob splitBlobs[][] = splitSort(sortedBlobs, BlobSort.Y, BlobSort.X);
      drawJoinedBlobs(splitBlobs[0], splitBlobs[1]);
    }
    img.endDraw();
    super.draw(blobs);
  }

  // Given an array of blobs, sorts that array and then splits into 2 halfs and sort those halfs.
  // Returns 2 element array containing the arrays for each half.
  // e.g. Blob splitBlobs[][] = splitSort(blobs, BlobSort.X, BlobSort.Y);
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
    img.stroke(fgcol);
    for(int i=0; i<b1.length; i++) {
      lazerLine(b1[i], b2[i]);
    }
  }

}
