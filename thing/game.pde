boolean isGame = false;

void game()
{
  if (keyPressed) {
        if (key == 'g' || key == 'G') {
          isGame = true;
        }
        if (key == 'h' || key == 'H') {
          isGame = false;
        }
  }
  
  if(isGame)
  {
    
  }
}
