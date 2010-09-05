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
   freqModulator = new Glide(ac, 1, 1);
   Function fmod = new Function(freqModulator) {
    public float calculate() {
        return x[0];
      }
    };
    
    modulatorLR = new Glide(ac, -1, 10);
    Function modFreq = new Function(modulatorLR) {
      public float calculate() {
        return x[0] * 1;
      }
    };
   
   WavePlayer lfo = new WavePlayer(ac, fmod, Buffer.SINE);
   modulatorUD = new Glide(ac, 1, 10);
   Function function = new Function(lfo,modulatorUD) {
      public float calculate() {
        return x[0] * x[1] + 800.0;
      }
    };
  
   LPRezFilter f = new LPRezFilter( ac, function, 0.94);
   f.addInput(n);
  
    Gain g = new Gain(ac, 1, 0.1);
    g.addInput(f);
      
    
    // println(modPan);
    WaveShaper ws = new WaveShaper(ac);
    ws.setPreGain(6.0);
    ws.setPostGain(0.5);
    ws.addInput(g);
    
  ac.out.addInput(ws);
  ac.out.addInput(lfo);
  
  }
  
  void draw( Blob[] blobs ) {
    if ( !visible ) return false;
    
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
      //freqModulator.setValue(myFM);
    }    
  }
  
  void hide() {
    println("hello hide noizer");
    ac.out.pause(true);
  }
  
  void show() {
    println("hello show noizer");
    ac.out.pause(false);
  }
}


