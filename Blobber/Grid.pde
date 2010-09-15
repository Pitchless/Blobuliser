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

    // Setup multi dimential array of grid sections
    int gridw = width/sizeX;    // Grid section width
    int gridh = height/sizeY;   // Grid section height
    GridSection grid[][] = new GridSection[sizeX][sizeY];
    for (int i=0; i<sizeX; i++) {
      for(int j=0; j<sizeY; j++) {
        GridSection sec = new GridSection();
        sec.center.x = (i*gridw)+(gridw/2);
        sec.center.y = (j*gridh)+(gridh/2);
        grid[i][j] = sec;
      }
    }

    // Sort the blobs onto the grid
    for (int i=0; i<blobs.length; i++) {
      Blob blob = blobs[i];
      int gridx = blob.centroid.x / gridw;
      int gridy = blob.centroid.y / gridh;
      grid[gridx][gridy].count++;
      grid[gridx][gridy].area+=blob.area;
    }

    img.beginDraw();
    img.background(0,0,0,0); // Clear transparent
    for (int i=0; i<sizeX; i++) {
      for(int j=0; j<sizeY; j++) {
        println(i + ", " + j + " count:" + grid[i][j]);
        GridSection sec = grid[i][j];
        img.fill(255);
        img.text( sec.count, sec.center.x, sec.center.y );
        img.fill(255,0,0);
        img.text( sec.area, sec.center.x, sec.center.y+12 );
      }
    }
    img.endDraw();
    super.draw(blobs);
  }

}

// Quick class to hold info on each grid section
class GridSection {
  Point center = new Point();
  int count = 0; // How many blobs
  int area  = 0; // Total area of blobs
}
