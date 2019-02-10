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

  void moveSnake(int turn) 
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


  void drawSnake(float w, float h) 
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
