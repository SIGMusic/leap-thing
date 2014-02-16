import org.jbox2d.callbacks.*;
import org.jbox2d.dynamics.contacts.Contact;
import org.jbox2d.collision.Manifold;

class ShapeContact implements ContactListener {
  void beginContact(Contact contact) {
    System.out.println("Contact!");
  }

  void endContact(Contact contact) {
    // do nothing
  }
  
  void preSolve(Contact contact, Manifold oldManifold){
     // do nothing 
  }
  
  void postSolve(Contact contact, ContactImpulse impulse){
    //do nothing 
  }
}

