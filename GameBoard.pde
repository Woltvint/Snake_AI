class GameBoard 
{
  
  
  char[][] Board;
  Snake snake;
  
  
  //drawing variables
  int offx;
  int offy;
  int w;
  int h;


  GameBoard(int boardx, int boardy, int bw, int bh, int ox, int oy) 
  {
    Board = new char[boardx][boardy];
    snake = new Snake(boardx/2,boardy/2,4,boardx * boardy);
    w = bw; 
    h = bh; 
    offx = ox; 
    offy = oy;
  }
  
  
  void drawBoard() 
  {
    translate(offx,offy);
    snake.drawSnake(w/Board.length,h/Board[0].length);
    translate(-offx,-offy);
  }
  
  
  void simSnake() 
  {
    boolean c = false;
    for (int i = 1;i < snake.partx.length;i++)
    {
      if (snake.partx[i] == snake.partx[0] && snake.party[i] == snake.party[0]) 
      {
        c = true;
      }
    }
    
    if (snake.partx[0] < 0 || snake.partx[0] > Board.length || snake.party[0] < 0 || snake.party[0] > Board[0].length) 
    {
      c = true;
    }
    
    
  }
}
