GameBoard[][] boards = new GameBoard[20][20]; //<>//

int gen = 0;
int highScore = 0;
int highIntScore = 0;

boolean drawSnakes = true;
boolean showInfo = true;

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
  frameRate(240);
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
      if (drawSnakes)
      {
        boards[x][y].drawBoard();
      }
      a = a || boards[x][y].snake.alive;
    }
  }

  if (!a) 
  {
    mutateGen();
  }

  if (showInfo) 
  {
    stroke(0);
    fill(255);
    rect(0, 0, 120, 70);
    fill(0);
    text("Gen: " + gen, 10, 20);
    text("HighScore: : " + highScore, 10, 40);
    text("IntScore: " + highIntScore, 10, 60);
  }
}

void keyPressed() 
{
  switch(keyCode)
  {
  case 'G':
    drawSnakes = !drawSnakes;
    break;
  case 'I':
    showInfo = !showInfo;
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

  //highscore update thing
  if (highScore < ar[ar.length-1].snake.parts) 
  {
    highScore = ar[ar.length-1].snake.parts;
  }
  //highintscore update thing
  if (highIntScore < ar[ar.length-1].score) 
  {
    highIntScore = round(ar[ar.length-1].score);
  }

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
        }
      } else
      {
        if (random(0, 100) < 10)
        {
          boards[x][y] = new GameBoard(40, 40, width/boards.length, height/boards[0].length, x * (width/boards.length), y * (height/boards[0].length));
        } else
        {
          boards[x][y] = new GameBoard(40, 40, width/boards.length, height/boards[0].length, x * (width/boards.length), y * (height/boards[0].length));
          boards[x][y].net = ar[ar.length-1].net;
        }
      }
    }
  }
  gen++;
}
