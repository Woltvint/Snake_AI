class GameBoard 
{
  Snake snake;
  NeuralNet net;
  int bx;
  int by;

  //score
  int score = 0;

  //food
  int foodx;
  int foody;
  int lastFood = 0;

  //drawing variables
  int offx;
  int offy;
  int w;
  int h;


  GameBoard(int boardx, int boardy, int bw, int bh, int ox, int oy) 
  {
    bx = boardx; 
    by = boardy;
    snake = new Snake(boardx/2, boardy/2, 4, boardx * boardy);
    net = new NeuralNet(3, 2, 2);

    w = bw; 
    h = bh; 
    offx = ox; 
    offy = oy;

    foodx = floor(random(1, bx));
    foody = floor(random(1, by));
  }


  void drawBoard() 
  {
    translate(offx, offy);
    snake.drawSnake((float)w/(float)bx, (float)h/(float)by);
    stroke(0);
    line(0, 0, 0, h);
    line(0, 0, w, 0);
    line(w, 0, w, h);
    line(0, h, w, h);
    rect(foodx*(float)w/(float)bx, foody*(float)h/(float)by, (float)w/(float)bx, (float)h/(float)by);
    translate(-offx, -offy);
  }


  void simSnake() 
  {
    boolean c = false;
    for (int i = 1; i < snake.partx.length; i++)
    {
      if (snake.partx[i] == snake.partx[0] && snake.party[i] == snake.party[0]) 
      {
        c = true;
      }
    }

    if (snake.partx[0] <= 0 || snake.partx[0] >= bx || snake.party[0] <= 0 || snake.party[0] >= by) 
    {
      c = true;
    }

    if (c) 
    {
      snake.alive = false;
    }

    if (snake.partx[0] == foodx && snake.party[0] == foody) 
    {
      foodx = floor(random(1, bx));
      foody = floor(random(1, by));
      snake.parts++;

      int i;
      for (i = 0; i < snake.partx.length; i++)
      {
        if (snake.partx[i] == -1) 
        {
          break;
        }
      }

      snake.partx[i] = snake.partx[i-1] + (snake.partx[i-1] - snake.partx[i-2]);
      snake.party[i] = snake.party[i-1] + (snake.party[i-1] - snake.party[i-2]);
      score += 10;
      lastFood = 0;
    } else
    {
      lastFood++;

      if (lastFood > 500) 
      {
        snake.alive = false;
      }
    }


    float[] input = new float[6];

    int frontx = snake.partx[0] + round(cos(snake.dir * HALF_PI));
    int fronty = snake.party[0] + -round(sin(snake.dir * HALF_PI));

    int leftx = snake.partx[0] + round(cos((snake.dir+1) * HALF_PI));
    int lefty = snake.party[0] + -round(sin((snake.dir+1) * HALF_PI));

    int rightx = snake.partx[0] + round(cos((snake.dir-1) * HALF_PI));
    int righty = snake.party[0] + -round(sin((snake.dir-1) * HALF_PI));

    boolean fc = false;
    boolean rc = false;
    boolean lc = false;

    for (int i = 0; i < snake.partx.length; i++) 
    {
      if (snake.partx[i] == frontx && snake.party[i] == fronty) 
      {
        fc = true;
      }

      if (snake.partx[i] == rightx && snake.party[i] == righty) 
      {
        rc = true;
      }

      if (snake.partx[i] == leftx && snake.party[i] == lefty) 
      {
        lc = true;
      }
    }

    if (fc) { 
      input[0] = 1;
    } else { 
      input[0] = 0;
    }
    if (rc) { 
      input[1] = 1;
    } else { 
      input[1] = 0;
    }
    if (lc) { 
      input[2] = 1;
    } else { 
      input[2] = 0;
    }

    if (abs(foodx - rightx) == abs(foodx - leftx) && abs(foody - righty) == abs(foody - lefty))
    {
      input[3] = 1;
      input[4] = 0;
      input[5] = 0;
    } else
    {
      if (abs(foodx - rightx) > abs(foodx - leftx) || abs(foody - righty) > abs(foody - lefty))
      {
        input[3] = 0;
        input[4] = 1;
        input[5] = 0;
      } else
      {
        input[3] = 0;
        input[4] = 0;
        input[5] = 1;
      }
    }

    float[] control;

    control = net.calcNet(input);

    if (control[0] > control[1] && control[0] > control[2]) 
    {
      snake.moveSnake(0);
      if (input[3] == 1) 
      {
        score += 1;
      } else
      {
        score += -1.5;
      }
    } else
    {
      if (control[1] > control[2]) 
      {
        snake.moveSnake(1);
        if (input[4] == 1) 
        {
          score += 1;
        } else
        {
          score += -1.5;
        }
      } else
      {
        snake.moveSnake(-1);
        if (input[5] == 1) 
        {
          score += 1;
        } else
        {
          score += -1.5;
        }
      }
    }
  }
}
