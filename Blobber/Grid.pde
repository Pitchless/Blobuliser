/**
 * Detect blobs in a grid. Shows number of blobs in each section.
 */
class Grid extends ImgLayer {

  int sizeX = 2;
  int sizeY = 2;
  
  // Config for random constructor
  float[] randFadePerFrame = { 0.4, 0.86, 0.988 };

  Grid() { randomise(); }

  Grid(int x, int y) {
    sizeX = x;
    sizeY = y;
  }

  void randomise() {
    super.randomise();
    this.fadePerFrame = randFadePerFrame[int(random(randFadePerFrame.length))];
  }

  void draw( Blob blobs[] ) {
    //fade();
    cycleColor();

    // Sort the blobs into a multi dimential array of grid section counts
    int grid[][] = new int[sizeX][sizeY];    
    int gridw = width/sizeX;    // Grid section width
    int gridh = height/sizeY;   // Grid section height
    for (int i=0; i<blobs.length; i++) {
      Blob blob = blobs[i];
      int gridx = blob.centroid.x / gridw;
      int gridy = blob.centroid.y / gridh;
      grid[gridx][gridy]++;
    }

    img.beginDraw();
    img.background(0,0,0,0); // Clear transparent
    for (int i=0; i<sizeX; i++) {
      for(int j=0; j<sizeY; j++) {
        println(i + ", " + j + " count:" + grid[i][j]);
        img.fill(255);
        img.text( grid[i][j], (i*gridw)+(gridw/2), (j*gridh)+(gridh/2) );
      }
    }
    img.endDraw();
    super.draw(blobs);
  }

}
