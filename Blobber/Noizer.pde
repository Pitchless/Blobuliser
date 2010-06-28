import beads.*;

Glide modulatorLR, modulatorUD, freqModulator;

class Noizer extends Layer {

  AudioContext ac;
  
  void setup() {
    visible = true;
    
    ac = new AudioContext();
    ac.start();
    Noise n = new Noise(ac);
  
   // this is per blob
   freqModulator = new Glide(ac, 1, 10);
   Function fmod = new Function(freqModulator) {
    public float calculate() {
      return x[0];
    }
  };
   
   WavePlayer lfo = new WavePlayer(ac, fmod, Buffer.SINE);
   modulatorUD = new Glide(ac, 1, 10);
   Function function = new Function(lfo,modulatorUD) {
      public float calculate() {
        return x[0] * x[1] + 800.0;
      }
    };
  
   LPRezFilter f = new LPRezFilter( ac, function, 0.99);
   f.addInput(n);
  
    Gain g = new Gain(ac, 1, 0.1);
    g.addInput(f);
      
    modulatorLR = new Glide(ac, -1, 10);
    Function modPan = new Function(modulatorLR) {
      public float calculate() {
        return x[0] * 1;
      }
    };
    // println(modPan);
  
    Panner p = new Panner(ac , modPan);
    p.addInput(g);
    
  ac.out.addInput(p);
  
  }
  
  Boolean draw( Blob[] blobs ) {
    // sound modulation stuff
    float myX, myY, myFM;
    if(blobs.length>0) {
      Point soundBlob1 = blobs[0].centroid;
      myX = map(soundBlob1.x, 0, width, -1, 1);
      // print(myX);
      myY = map(soundBlob1.y, 0, height, 3000, 0);
      
      myFM = map(blobs.length, 0, blobs.length, 0.1, 10.0);
      modulatorLR.setValue(myX);
      modulatorUD.setValue(myY);
      freqModulator.setValue(myFM);
    }
    
    return true;
  }
}


