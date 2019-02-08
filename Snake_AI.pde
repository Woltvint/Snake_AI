GameBoard p1, p2, p3 , p4;

void setup() 
{
  size(900,900);
  p1 = new GameBoard(30,30,450,450,0,0);
  p2 = new GameBoard(30,30,450,450,450,0);
  p3 = new GameBoard(30,30,450,450,0,450);
  p4 = new GameBoard(30,30,450,450,450,450);
  frameRate(60);
}

void draw() 
{
  background(255);
  p1.drawBoard();
  p2.drawBoard();
  p3.drawBoard();
  p4.drawBoard();
}

void keyPressed() 
{
  switch(keyCode)
    {
      case 'A':
        p1.snake.moveSnake(1);
        p2.snake.moveSnake(1);
        p3.snake.moveSnake(1);
        p4.snake.moveSnake(1);
      break;
      
      case 'D':
        p1.snake.moveSnake(-1);
        p2.snake.moveSnake(-1);
        p3.snake.moveSnake(-1);
        p4.snake.moveSnake(-1);
      break;
      
      case 'W':
        p1.snake.moveSnake(0);
        p2.snake.moveSnake(0);
        p3.snake.moveSnake(0);
        p4.snake.moveSnake(0);
      break;
      
      case 'G':
        print("a"); //<>//
      break;
      
    }
}
