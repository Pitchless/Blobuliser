import beads.*;

class FModer extends Layer {
  
  Glide carrierFreq,modFreqRatio;
  int frameCounter;
  
  float myX, myY;

  int blarg;

  AudioContext ac;

  FModer() {
  
  }
  
  FModer(int blarg) {
    this.blarg = blarg;
  }
  
  void setup() {
    visible = true;

    ac = new AudioContext();
    ac.start();

    carrierFreq = new Glide(ac, 500);
    modFreqRatio = new Glide(ac, 1);
    Function modFreq = new Function(carrierFreq, modFreqRatio) {
      public float calculate() {
        return x[0] * x[1];
      }
    };
    
    WavePlayer freqModulator = new WavePlayer(ac, modFreq, Buffer.SINE);
    Function carrierMod = new Function(freqModulator, carrierFreq) {
      public float calculate() {
        return x[0] * 400.0 + x[1];    
      }
    };
    
    WavePlayer freqModulator2 = new WavePlayer(ac, modFreq, Buffer.SINE);
    Function carrierMod2 = new Function(freqModulator, carrierFreq) {
      public float calculate() {
        return x[0] * 350.0 + x[1];    
      }
    };
    
    
    
    WavePlayer wp1 = new WavePlayer(ac, carrierMod, Buffer.SINE);
    Gain g = new Gain(ac, 1, 0.15);
    g.addInput(wp1);
    ac.out.addInput(g);
    
    WavePlayer wp2 = new WavePlayer(ac, carrierMod2, Buffer.SINE);
    Gain g2 = new Gain(ac, 1, 0.15);
    g2.addInput(wp2);
    ac.out.addInput(g2);
    
    ac.start();
  }

  void draw( Blob[] blobs ) {
    
    
    // sound modulation stuff

    if(blobs.length>0) {
      Point soundBlob1 = blobs[0].centroid;
      myX = map(soundBlob1.y, 0, height, 0.01, 150);
      myY = map(soundBlob1.x, 0, width, 4.0, 60);

      carrierFreq.setValue(myX);
      modFreqRatio.setValue(myY);
      
      // carrierFreq2.setValue(myX);
      // modFreqRatio2.setValue(myY);
    }

  }
  
  void hide() {
    println("hello hide fmod");
    ac.out.pause(true);
  }
  
  void show() {
    println("hello show fmod");
    ac.out.pause(false);
  }
}



