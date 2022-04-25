#include "L138_LCDK_aic3106_init.h"
#include "readme.cof"

#define mu 1E-11 // learning rate
#define N 128 // length of delay line/adaptive filter
#define NUM_SECTIONS 128 // number of weights in synthetic transfer function

AIC31_data_type codec_data;

float weights[N]; // adaptive filter weights
float x[N]; //  delay line
float w[NUM_SECTIONS][2]; // synthetic transfer functino weights

interrupt void interrupt4(void)
{
	short i;
	float input, refnoise, signal, signoise, wn, yn, error;

	codec_data.uint = input_sample();

	refnoise =(codec_data.channel[LEFT]); // noise sensor - on outside of headphones

	input = refnoise;

    for (i=0; i < NUM_SECTIONS; i++) 
    // filter refnoise (noise sensor input) 
    //	to emulate transfer function of headphone wall
    // readme.cof contains a low pass 3rd order FIR cheby filter
    {

    	wn = input - a[i][1]*w[i][0] - a[i][2]*w[i][1];
        yn = b[i][0]*wn + b[i][1]*w[i][0] + b[i][2]*w[i][1];
        w[i][1] = w[i][0];
        w[i][0] = wn;

        input = yn;
    }

	yn=0.0;
	x[0] = refnoise;

	for (i = 0; i < N; i++) // compute adaptive filter output (w'x)
	{
			yn += (weights[i] * x[i]);
	}

	error = - yn; // compute error

	for (i = N-1; i >= 0; i--) // update weights and delay line
	{
		weights[i] = weights[i] + mu*error*x[i];
		x[i] = x[i-1];
	}

	codec_data.channel[LEFT]= ((uint16_t)(error));
	codec_data.channel[RIGHT]= ((uint16_t)(error));
	output_sample(codec_data.uint);
	return;
	}

int main()
{
	int i;
	for (i= 0; i < N; i++) // initialize delay line
	{
		weights[i] = 0;
		x[i] = 0;
	}
	for (i= 0; i < NUM_SECTIONS; i++) //initialize weihts
	{
		w[i][0] = 0.0;
		w[i][1] = 0.0;
	}

	L138_initialise_intr(FS_8000_HZ,ADC_GAIN_0DB,DAC_ATTEN_0DB,LCDK_LINE_INPUT);
	while(1);
}
