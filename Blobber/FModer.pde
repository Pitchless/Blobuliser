import beads.*;

class FModer extends Layer {
  
  Glide carrierFreq, freqModulator,modFreqRatio;

  AudioContext ac;

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
    WavePlayer wp = new WavePlayer(ac, carrierMod, Buffer.SINE);
    Gain g = new Gain(ac, 1, 0.1);
    g.addInput(wp);
    ac.out.addInput(g);
    ac.start();
  }

  Boolean draw( Blob[] blobs ) {
    // sound modulation stuff
    float myX, myY, myFM;
    if(blobs.length>0) {
      Point soundBlob1 = blobs[0].centroid;
      myX = map(soundBlob1.x, 0, width, 0.5, 500);
      println("Carrier: " + myX);
      myY = map(soundBlob1.y, 0, height, 0.01, 10);
      println("ModFreq: " + myY);
      myFM = map(soundBlob1.y, 0, height, 0.1, 10.0);
      carrierFreq.setValue(myX);
      modFreqRatio.setValue(myY);
    }

    return true;
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



