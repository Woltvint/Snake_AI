import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Snake_AI extends PApplet {

GameBoard[][] boards = new GameBoard[20][20];
int gen = 0;
boolean draw = true;

public void setup() 
{
  
  for (int x = 0; x < boards.length; x++) 
  {
    for (int y = 0; y < boards[0].length; y++) 
    {
      boards[x][y] = new GameBoard(40, 40, width/boards.length, height/boards[0].length, x * (width/boards.length), y * (height/boards[0].length));
    }
  }
  frameRate(240);
}

public void draw() 
{
  background(255);

  boolean a = false;

  for (int x = 0; x < boards.length; x++) 
  {
    for (int y = 0; y < boards[0].length; y++) 
    {
      boards[x][y].simSnake();
      if (draw)
      boards[x][y].drawBoard();
      
      a = a || boards[x][y].snake.alive;
    }
  }

  if (!a) 
  {
    mutateGen();
  }
}

public void keyPressed() 
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
    draw = !draw;
    break;
  }
}


public void mutateGen() 
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

  println("gen: " +gen);
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
        }
      } else
      {
        if (random(0,100) < 50)
        {
        boards[x][y] = new GameBoard(40, 40, width/boards.length, height/boards[0].length, x * (width/boards.length), y * (height/boards[0].length));
        }
        else
        {
          boards[x][y] = new GameBoard(40, 40, width/boards.length, height/boards[0].length, x * (width/boards.length), y * (height/boards[0].length));
          boards[x][y].net = ar[ar.length-1].net;
        }
    }
    }
  }
  gen++;
}
class GameBoard 
{
  Snake snake;
  NeuralNet net;
  int bx;
  int by;

  //score
  float score = 0;

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
    net = new NeuralNet(3, 3, 3);

    w = bw; 
    h = bh; 
    offx = ox; 
    offy = oy;

    foodx = floor(random(2, bx-1));
    foody = floor(random(2, by-1));
  }


  public void drawBoard() 
  {
    translate(offx, offy);
    if (snake.alive) 
    {
    snake.drawSnake((float)w/(float)bx, (float)h/(float)by);
    stroke(0);
    line(0, 0, 0, h);
    line(0, 0, w, 0);
    line(w, 0, w, h);
    line(0, h, w, h);
    rect(foodx*(float)w/(float)bx, foody*(float)h/(float)by, (float)w/(float)bx, (float)h/(float)by);
    }
    else
    {
      stroke(0);
      fill(0);
      rect(0,0,w,h);
    }
    translate(-offx, -offy);
  }


  public void simSnake() 
  {
    if (!snake.alive) {return;}
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
      foodx = floor(random(2, bx-1));
      foody = floor(random(2, by-1));
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
      score += 50;
      lastFood = 0;
    } else
    {
      lastFood++;

      if (lastFood > 300) 
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
        score += -1.5f;
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
          score += -1.5f;
        }
      } else
      {
        snake.moveSnake(-1);
        if (input[5] == 1) 
        {
          score += 1;
        } else
        {
          score += -1.5f;
        }
      }
    }
  }
}
class NeuralNet 
{
  ArrayList<NeuronLayer> l = new ArrayList();

  NeuralNet(int on, int sn, int sl) 
  {
    for (int i = 0; i < sl; i++)
    {
      if (i == sl-1) 
      {
        l.add(new NeuronLayer(on));
      } else
      {
        l.add(new NeuronLayer(sn));
      }
    }
  }

  public float[] calcNet(float[] input) 
  {
    float[] output = input;

    for (int i = 0; i < l.size(); i++) 
    {
      output = l.get(i).calcLayer(output);
    }

    return output;
  }


  public NeuralNet mutateNet() 
  {
    NeuralNet net = new NeuralNet(0, 0, 0);

    for (int i = 0; i < l.size(); i++) 
    {
      net.l.add(l.get(i).mutateLayer());
    }

    return net;
  }
}


class NeuronLayer 
{
  float newNeuronChance = 0.5f;

  ArrayList<Neuron> n = new ArrayList();

  NeuronLayer(int startNeurons) 
  {
    for (int i = 0; i < startNeurons; i++) 
    {
      n.add(new Neuron());
    }
  }

  public float[] calcLayer(float[] input) 
  {
    float[] output = new float[n.size()];

    for (int i = 0; i < n.size(); i++) 
    {
      output[i] = n.get(i).calcNeuron(input);
    }

    return output;
  }

  public NeuronLayer mutateLayer() 
  {
    NeuronLayer l = new NeuronLayer(0);

    for (int i = 0; i < n.size(); i++) 
    {
      l.n.add(n.get(i).mutateNeuron());
    }

    if (random(0.0f, 100.0f) < newNeuronChance) 
    {
      l.n.add(new Neuron());
    }

    return l;
  }
}

class Neuron 
{
  float mutationChance = 10;
  float mutationRate = 0.1f;

  float[] w;
  float b;

  Neuron() 
  {
    b = random(-1, 1);
    w = new float[100];
    for (int i = 0;i < 100;i++) 
    {
      w[i] = random(-1, 1);
    }
  }

  public float calcNeuron(float[] input) 
  {
    float output = b;

    for (int i = 0; i < input.length; i++) 
    {
      output += w[i] * input[i];
    }

    return sigmoid(output);
  }

  public Neuron mutateNeuron() 
  {
    Neuron n = new Neuron();

    for (int i = 0; i < w.length; i++)
    {
      if (random(0.0f, 100.0f) < mutationChance)
      {
        n.w[i] = w[i] + random(-mutationRate, mutationRate);
      }
      else
      {
        n.w[i] = w[i];
      }
    }

    if (random(0.0f, 100.0f) < mutationChance)
    {
      n.b = b + random(-mutationRate, mutationRate);
    }
    else
    {
      n.b = b;
    }

    return n;
  }



  public float sigmoid(float x) 
  {
    return 1.0f / (1.0f + (float)Math.exp(-x));
  }
}
class Snake 
{
  int[] partx;
  int[] party;
  int dir;
  int parts = 4;



  boolean alive = true;

  Snake(int headx, int heady, int startLength, int maxLength) 
  {
    partx = new int[maxLength];
    party = new int[maxLength];

    for (int i = 0; i < maxLength; i++)
    {
      partx[i] = -1;
      party[i] = -1;
    }

    partx[0] = headx;
    party[0] = heady;

    for (int i = 1; i < startLength; i++) 
    {
      partx[i] = headx;
      party[i] = heady+i;
    }

    dir = 1;
  }

  public void moveSnake(int turn) 
  {

    if (!alive) {
      return;
    }
    //move all parts to the pos of parts before them
    for (int i = partx.length-1; i > 0; i--) 
    {
      if (partx[i] > -1 && party[i] > -1) 
      {
        partx[i] = partx[i-1];
        party[i] = party[i-1];
      }
    }

    //move the head
    switch(turn) 
    {
    case 0:
      partx[0] += round(cos(dir * HALF_PI));
      party[0] += -round(sin(dir * HALF_PI));
      break;

    case 1: 
      dir++;
      partx[0] += round(cos((dir) * HALF_PI));
      party[0] += -round(sin((dir) * HALF_PI));

      break;

    case -1:
      dir--;
      partx[0] += round(cos((dir) * HALF_PI));
      party[0] += -round(sin((dir) * HALF_PI));

      break;
    }

    if (dir > 3) 
    {
      dir = 0;
    }

    if (dir < 0) 
    {
      dir = 3;
    }
  }


  public void drawSnake(float w, float h) 
  {


    for (int i = 0; i < partx.length; i++) 
    {
      if (partx[i] > -1 && party[i] > -1)
      {
        stroke((i*16)%180);
        fill((i*16)%180);
        rect(partx[i]*w, party[i]*h, w, h);
      }
    }
  }
}
  public void settings() {  size(900, 900); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Snake_AI" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
