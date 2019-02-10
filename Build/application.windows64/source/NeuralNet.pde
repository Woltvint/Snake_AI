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

  float[] calcNet(float[] input) 
  {
    float[] output = input;

    for (int i = 0; i < l.size(); i++) 
    {
      output = l.get(i).calcLayer(output);
    }

    return output;
  }


  NeuralNet mutateNet() 
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
  float newNeuronChance = 0.5;

  ArrayList<Neuron> n = new ArrayList();

  NeuronLayer(int startNeurons) 
  {
    for (int i = 0; i < startNeurons; i++) 
    {
      n.add(new Neuron());
    }
  }

  float[] calcLayer(float[] input) 
  {
    float[] output = new float[n.size()];

    for (int i = 0; i < n.size(); i++) 
    {
      output[i] = n.get(i).calcNeuron(input);
    }

    return output;
  }

  NeuronLayer mutateLayer() 
  {
    NeuronLayer l = new NeuronLayer(0);

    for (int i = 0; i < n.size(); i++) 
    {
      l.n.add(n.get(i).mutateNeuron());
    }

    if (random(0.0, 100.0) < newNeuronChance) 
    {
      l.n.add(new Neuron());
    }

    return l;
  }
}

class Neuron 
{
  float mutationChance = 10;
  float mutationRate = 0.1;

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

  float calcNeuron(float[] input) 
  {
    float output = b;

    for (int i = 0; i < input.length; i++) 
    {
      output += w[i] * input[i];
    }

    return sigmoid(output);
  }

  Neuron mutateNeuron() 
  {
    Neuron n = new Neuron();

    for (int i = 0; i < w.length; i++)
    {
      if (random(0.0, 100.0) < mutationChance)
      {
        n.w[i] = w[i] + random(-mutationRate, mutationRate);
      }
      else
      {
        n.w[i] = w[i];
      }
    }

    if (random(0.0, 100.0) < mutationChance)
    {
      n.b = b + random(-mutationRate, mutationRate);
    }
    else
    {
      n.b = b;
    }

    return n;
  }



  float sigmoid(float x) 
  {
    return 1.0f / (1.0f + (float)Math.exp(-x));
  }
}
