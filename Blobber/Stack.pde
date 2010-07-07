/*
 * A group/stack of Layers.
 */

class Stack extends Layer {

  ArrayList layers;

  Stack() {
    layers = new ArrayList();
  }
  
  void add(Layer layer) {
    layers.add(layer);
  }

  Layer get(int i) {
    return (Layer)layers.get(i);
  }
  
  int size() {
    return layers.size();
  }
  
  // Toggle visible state of layer in stack
  void toggle( int i ) {
    Layer layer = (Layer)layers.get(i);
    if ( layer.visible ) { layer.hide(); } else { layer.show(); }
  }
  
  // Show only the given layer, hide all the rest.
  void toggleOn( int layerOn ) {
    for ( int i=0; i<layers.size(); i++ ) {
      Layer layer = (Layer)layers.get(i);
      if ( i==layerOn ) { layer.show(); } else { layer.hide(); } 
    }
  }

  // Actuall hide all the layers in the stack. Just using hide() will stop
  // all the sub layers from getting draw() called, but wont actually hide() them.
  void hideAll() {
    for ( int i=0; i<layers.size(); i++ ) {
      Layer layer = (Layer)layers.get(i);
      layer.hide();
    }    
  }

  void setup() {
    for ( int i=0; i<layers.size(); i++ ) {
      Layer layer = (Layer)layers.get(i);
      layer.setup();
    }
  }

  Boolean draw( Blob[] blobs ) {
    if ( !visible) return false; 
    for ( int i=0; i<layers.size(); i++ ) {
      Layer layer = (Layer)layers.get(i);
      if ( layer.visible ) layer.draw(blobs);
    }
    return true;
  }
}
