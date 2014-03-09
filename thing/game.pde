boolean isGame = false;
int score = 0;

void game()
{
  if (keyPressed) {
        if (key == 'g' || key == 'G') {
          isGame = true;
        }
        if (key == 'h' || key == 'H') {
          isGame = false;
        }
        if (key == 'r' || key == 'R') {
          score = 0;
        }
  }
  
  if(isGame)
  {
    textFont(f,40);
    fill(0, 0, 100);
    text("Score: " + score, width-200, 40);
    /*
    for(Shape b: shapes)
    {
      if(b.getY() < 0)
      {
        score++;
        b.remove();
      }
    }
    */
    
    for (int i = shapes.size()-1; i >= 0; i--) {
      Shape b = shapes.get(i);
      if (b.getX() < -15 || b.getX() > width+15) {
        score++;
        shapes.remove(i);
      }
    }
  }
}
