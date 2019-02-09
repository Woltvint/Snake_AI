GameBoard[][] boards = new GameBoard[20][20];

void setup() 
{
  size(900, 900);
  for (int x = 0; x < boards.length; x++) 
  {
    for (int y = 0; y < boards[0].length; y++) 
    {
      boards[x][y] = new GameBoard(40, 40, width/boards.length, height/boards[0].length, x * (width/boards.length), y * (height/boards[0].length));
    }
  }
  frameRate(60);
}

void draw() 
{
  background(255);

  boolean a = false;

  for (int x = 0; x < boards.length; x++) 
  {
    for (int y = 0; y < boards[0].length; y++) 
    {
      boards[x][y].simSnake();
      boards[x][y].drawBoard();
      a = a || boards[x][y].snake.alive;
    }
  }

  if (!a) 
  {
    mutateGen(); //<>//
  }
}

void keyPressed() 
{
  switch(keyCode)
  {/*
 case 'A':
   boards[0][0].snake.moveSnake(1);
   break;
   
   case 'D':
   boards[0][0].snake.moveSnake(-1);
   break;
   
   case 'W':
   boards[0][0].snake.moveSnake(0);
   break;
   */
  case 'G':
    print("a");
    break;
  }
}


void mutateGen() 
{

  //array for sorting
  GameBoard[] ar = new GameBoard[boards.length * boards[0].length];
  int s = 0;
  for (int x = 0; x < boards.length; x++) 
  {
    for (int y = 0; y < boards[0].length; y++) 
    {
      ar[s] = boards[x][y];
      s++;
    }
  }

  //sorting loop
  for (int i = 0; i < ar.length-1; i++)
  {
    int min = i;
    for (int j = i+1; j < ar.length; j++)
      if (ar[j].score < ar[min].score) min = j;
    GameBoard temp = ar[i];
    ar[i] = ar[min];
    ar[min] = temp;
  }

  int scoremax = 0;

  //score addition
  for (int a = 0; a < ar.length; a++) {
    scoremax += ar[a].score;
  }
  
  println(ar[ar.length-1].snake.parts);

  for (int x = 0; x < boards.length; x++) 
  {
    for (int y = 0; y < boards[0].length; y++) 
    {
      if (!(x == boards.length-1)) {
        while (true) 
        {
          int b = ar.length - (int)random(0, 10)-1;

          if (random(-1, scoremax) < ar[b].score) 
          {
            boards[x][y].net = ar[b].net.mutateNet();
            boards[x][y].score = 0;
            boards[x][y].snake = new Snake(ar[b].bx/2, ar[b].by/2, 4, ar[b].bx * ar[b].by);
            boards[x][y].lastFood = 0;
            break;
          }
          
          if (x == 0) 
      {
            boards[x][y].net = ar[ar.length-1].net;
            boards[x][y].score = 0;
            boards[x][y].snake = new Snake(ar[b].bx/2, ar[b].by/2, 4, ar[b].bx * ar[b].by);
            boards[x][y].lastFood = 0;
            break;
      }
        }
      } 
      else
      {
        boards[x][y] = new GameBoard(40, 40, width/boards.length, height/boards[0].length, x * (width/boards.length), y * (height/boards[0].length));
      }
      
      
    }
  }
}
