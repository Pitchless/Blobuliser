/*
 * Horizontal or Vertical Lines Layer
 */
class SLines extends ImgLayer {

  static final int HORI = 1;
  static final int VERT = 2;

  int direction = HORI;
  
  SLines() {
    this.fadePerFrame = 0.9;
  }
  
  SLines(int direction) {
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
      Arrays.sort(sortedBlobs, BlobSort.Y);  // Yes, Horizontal is a y sort, think about it ;-)
      drawLines(sortedBlobs);
    }
    if ((direction & VERT)==VERT) {
      Arrays.sort(sortedBlobs, BlobSort.X);
      drawLines(sortedBlobs);
    }
    img.endDraw();
    super.draw(blobs);
  }

  void drawLines(Blob blobs[]) {
      int len = blobs.length % 2 == 0 ? blobs.length : blobs.length -1;
      img.stroke(fgcol);
      for( int i=0; i<len; i+=2 ) {
         lazerLine(blobs[i], blobs[i+1]);
      }
  }

}
