class Snake 
{
  color snakeColor = color(0,0,255);
  
  int[] partx;
  int[] party;
  int dir;
  
  Snake(int headx, int heady, int startLength, int maxLength) 
  {
    partx = new int[maxLength];
    party = new int[maxLength];
    
    for (int i = 0;i < maxLength;i++)
    {
      partx[i] = -1;
      party[i] = -1;
    }
    
    partx[0] = headx;
    party[0] = heady;
    
    for (int i = 1;i < startLength;i++) 
    {
      partx[i] = headx;
      party[i] = heady+i;
    }
    
    dir = 1;
  }
  
  void moveSnake(int turn) 
  {
    //move all parts to the pos of parts before them
    for (int i = partx.length-1;i > 0;i--) 
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
        partx[0] += cos(dir * HALF_PI);
        party[0] += -sin(dir * HALF_PI);
      break;
      
      case 1: 
        partx[0] += cos((dir + 1) * HALF_PI);
        party[0] -= sin((dir + 1) * HALF_PI);
        dir++;
      break;
      
      case -1:
        partx[0] += cos((dir - 1) * HALF_PI);
        party[0] -= sin((dir - 1) * HALF_PI);
        dir--;
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
  
  
  void drawSnake(int w, int h) 
  {
    stroke(snakeColor);
    fill(snakeColor);
    
    for (int i = 0;i < partx.length;i++) 
    {
      if (partx[i] > -1 && party[i] > -1)
      rect(partx[i]*w,party[i]*h,w,h);
    }
    
  }
  
}
