import beads.*;
import java.io.*;
  
class BackgroundGranulation extends Layer {

  String[] loadFilenames;
  int timeSinceStart;
  
  AudioContext ac;
  	   		   
  void setup() {
    
    /* dual sample random granulator background
    /  takes two random samples from the data folder and plays them back straightish 
    /  before granulating the funk out of them
    */
  
    loadFilenames();
    ac = new AudioContext();
  
    String audioFile = dataPath("") + loadFilenames[int(random(loadFilenames.length))];
    GranularSamplePlayer player = new GranularSamplePlayer(ac, SampleManager.sample(audioFile));
  
     //loop the sample at its end points
     player.setLoopType(SamplePlayer.LoopType.LOOP_ALTERNATING);
     player.getLoopStartEnvelope().setValue(0);
     player.getLoopEndEnvelope().setValue(SampleManager.sample(audioFile).getLength());
     //control the rate of grain firing
     Envelope grainIntervalEnvelope = new Envelope(ac, 100);
     grainIntervalEnvelope.addSegment(20, 10000);
     player.setGrainIntervalEnvelope(grainIntervalEnvelope);
     //control the playback rate
     Envelope rateEnvelope = new Envelope(ac, 1);
     rateEnvelope.addSegment(1, 5000);
     rateEnvelope.addSegment(0, 5000);
     rateEnvelope.addSegment(0, 2000);
     rateEnvelope.addSegment(-0.1, 2000);
     player.setRateEnvelope(rateEnvelope);
     //a bit of noise can be nice
     player.getRandomnessEnvelope().setValue(0.01);
  
    Gain g = new Gain(ac, 2, 0.6); // master volume granulated sample 1
    g.addInput(player);
    ac.out.addInput(g);
    
    String audioFile2 = dataPath("") + loadFilenames[int(random(loadFilenames.length))];
    GranularSamplePlayer player2 = new GranularSamplePlayer(ac, SampleManager.sample(audioFile2));
  
     //loop the sample at its end points
     player2.setLoopType(SamplePlayer.LoopType.LOOP_ALTERNATING);
     player2.getLoopStartEnvelope().setValue(0);
     player2.getLoopEndEnvelope().setValue(SampleManager.sample(audioFile).getLength());
     //control the rate of grain firing
     Envelope grainIntervalEnvelope2 = new Envelope(ac, 100);
     grainIntervalEnvelope2.addSegment(20, 10000);
     player2.setGrainIntervalEnvelope(grainIntervalEnvelope2);
     //control the playback rate
     Envelope rateEnvelope2 = new Envelope(ac, 1);
     rateEnvelope2.addSegment(1, 5000);
     rateEnvelope2.addSegment(0, 5000);
     rateEnvelope2.addSegment(0, 2000);
     rateEnvelope2.addSegment(-0.1, 2000);
     player2.setRateEnvelope(rateEnvelope2);
     //a bit of noise can be nice
     player2.getRandomnessEnvelope().setValue(0.01);
  
    Gain g2 = new Gain(ac, 2, 0.6); // master volume granulated sample 2
    g2.addInput(player2);
    
    ac.out.addInput(g2);
    ac.start();
  }
  
  Boolean draw( Blob[] blobs ) {
//    timeSinceStart ++;
//    
//    if(timeSinceStart > 10000){
//      String audioFile = dataPath("") + loadFilenames[int(random(loadFilenames.length))];
//      GranularSamplePlayer player = new GranularSamplePlayer(ac, SampleManager.sample(audioFile));
//      String audioFile2 = dataPath("") + loadFilenames[int(random(loadFilenames.length))];
//      GranularSamplePlayer player2 = new GranularSamplePlayer(ac, SampleManager.sample(audioFile));
//      println("Reseting the granular sample players");
//    }
    return true;
    
  }
  
  // this is how we pull all of the audio files out of the data folder
  void loadFilenames() {
    java.io.File folder = new java.io.File(dataPath("")); // reads files from data folder
    java.io.FilenameFilter imgFilter = new java.io.FilenameFilter() {boolean accept(File dir, String name) {return name.toLowerCase().endsWith(".wav") || name.toLowerCase().endsWith(".aif");} };
    loadFilenames = folder.list(imgFilter);
    for(int i =0; i< loadFilenames.length; i++) {
    }
  }
    
  void hide() {
    println("hello hide background");
    ac.out.pause(true);
  }
  
  void show() {
    println("hello show backgound");
    ac.out.pause(false);
  }
}
