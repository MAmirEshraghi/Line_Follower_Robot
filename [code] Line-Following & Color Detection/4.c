/*******************************************************
Project : Line Follower Robot with ability of Color Detection
Version : Final
Date    : 04/12/2015
Author  : Mohammad Amir Eshraghi 
Company : www.github.com/MAmirEshraghi/Line_Follower_Robot
Comments: Description and Album available on my GitHub.

Chip type               : ATmega64A
Program type            : Application
AVR Core Clock frequency: 16/000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*******************************************************/

#include <mega64a.h>
#include <stdlib.h>
#include <stdio.h>
#include <delay.h>
#include <alcd.h>

//#define LEDG PORTF.1
//#define LEDY PORTF.2
//#define LEDR PORTF.3

#define SWR  PINE.3
#define SWM  PINE.1
#define SWL  PINE.2

#define on  1
#define off 0

#define CW    0
#define CCW   1

#define In1MotR PORTA.1
#define In2MotR PORTA.2
#define In1MotL PORTA.0
// #define In2MotL PORTF.7

#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

#define SEN1   (PIND.0^i)
#define SEN2   (PIND.1^i)
#define SEN3   (PIND.2^i)
#define SEN4   (PIND.3^i)
#define SEN5   (PIND.4^i)
#define SEN6   (PIND.5^i)
#define SEN7   (PIND.6^i)
#define SEN8   (PIND.7^i)

#define SEN9   (PING&0b00000001)    //PING.0
#define SEN9N  (PING&0b00000000)    //PING.0

#define SEN10  (PING&0b00000010)    //PING.1
#define SEN10N (PING&0b00000000)    //PING.1

#define SEN11  (PINC.0^i)
#define SEN12  (PINC.1^i)
#define SEN13  (PINC.2^i)
#define SEN14  (PINC.3^i)
#define SEN15  (PINC.4^i)
#define SEN16  (PINC.5^i)
#define SEN17  (PINC.6^i)
#define SEN18  (PINC.7^i)

#define SEN19  (PING&0b00000100)    //PING.2
#define SEN19N (PING&0b00000000)    //PING.2

#define SEN20  (PINA.7^i)
#define SEN21  (PINA.6^i)
#define SEN22  (PINA.3^i)
#define SEN23  (PINA.4^i)
#define SEN24  (PINA.5^i)

#define VolomADC   read_adc(6)

#define adcNumberL read_adc(3);
#define adcNumberR read_adc(4);
#define KeySen PORTE.0
#define N 2

#define SWG (PINF&0b00100000)

//--------------------------------------------------

bit i=0;
int a[23];
int l;
bit DirectionR,DirectionL;
unsigned char SpeedR,SpeedL;

unsigned char V;
int RS;
int LsenKeyON,RsenKeyON,LsenKeyOFF,RsenKeyOFF;
unsigned int ColorNumL,ColorNumR,ColorCalL,ColorCalR,c,d;

char m[33];

int p;
//--------------------------------------------------



interrupt [TIM0_OVF] void timer0_ovf_isr(void)
 {
  static bit K0=0;

  if ( K0 )
  {
   TCNT0 = 255 - SpeedR;
   K0=0;

   if      ( DirectionR ==  CW )
   {
    In1MotR = 1;
    In2MotR = 0;
   }
   else if ( DirectionR == CCW )
   {
    In1MotR = 0;
    In2MotR = 1;
   }

  }
  else if ( !K0 )
  {
   TCNT0=SpeedR;
   K0=1;

   In1MotR = 0;
   In2MotR = 0;
  }

 }
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
 {
  static bit KP2=0;
  if(KP2)
  {
    TCNT2=255-SpeedL;
    KP2=0;
    if(DirectionL==CW)
    {
        In1MotL=0;
        //In2MotL=1;
        PORTF|=0b10000000;
    }
    else if(DirectionL==CCW)
    {
        In1MotL=1;
        //In2MotL=0;
        PORTF&=0b01111111;
    }
  }
  else if(!KP2)
  {
    TCNT2=SpeedL;
    KP2=1;

    In1MotL=0;
    //In2MotL=0;
    PORTF&=0b01111111;
  }
 }

unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}

void LEDG (char a)
 {
       if ( a == 1)PORTF|=0b00000100;
  else if ( a == 0)PORTF&=0b11111011;
 }
void LEDY (char a)
 {
       if ( a == 1)PORTF|=0b00000010;
  else if ( a == 0)PORTF&=0b11111101;
 }
void LEDR (char a)
 {
       if ( a == 1)PORTF|=0b00000001;
  else if ( a == 0)PORTF&=0b11111110;
 }

void Move(char DL,char DR,unsigned char SL,unsigned char SR)
{
    DirectionL=DL;
    DirectionR=DR;
    SpeedL=SL;
    SpeedR=SR;
}

void CalR()
 {
  int RKeyON,RKeyOFF;

  ColorCalR=RKeyON=RKeyOFF=0;

  KeySen=off;

  for (c=0;c<N;c++)
  {
   RKeyOFF+=adcNumberR;
  }

  KeySen=on;

  for (d=0;d<N;d++)
  {
   RKeyON+=adcNumberR;
  }

  KeySen=off;

  RKeyOFF/=N;
  RKeyON /=N;

  ColorCalR = RKeyON - RKeyOFF;

  lcd_clear();
  lcd_gotoxy(0,0);
  sprintf(m,"Right= %d",ColorCalR);
  lcd_puts(m);
 }
void CalL()
 {
  int LKeyON,LKeyOFF;

  ColorCalL=LKeyON=LKeyOFF=0;

  KeySen=off;

  for (c=0;c<N;c++)
  {
   LKeyOFF+=adcNumberL;
  }

  KeySen=on;

  for (d=0;d<N;d++)
  {
   LKeyON+=adcNumberL;
  }

  KeySen=off;

  LKeyOFF/=N;
  LKeyON /=N;

  ColorCalL = LKeyON - LKeyOFF;

  lcd_clear();
  lcd_gotoxy(0,0);
  sprintf(m,"Left= %d",ColorCalL);
  lcd_puts(m);
 }

void Color()
 {
  ColorNumL=LsenKeyON=LsenKeyOFF=0;
  ColorNumR=RsenKeyON=RsenKeyOFF=0;

  KeySen=off;

  for (c=0;c<N;c++)
  {
   LsenKeyOFF+=adcNumberL;
   RsenKeyOFF+=adcNumberR;
  }

  KeySen=on;

  for (d=0;d<N;d++)
  {
   LsenKeyON+=adcNumberL;
   RsenKeyON+=adcNumberR;
  }

  KeySen=off;

  LsenKeyOFF/=N;
  LsenKeyON /=N;
  RsenKeyOFF/=N;
  RsenKeyON /=N;

  ColorNumL = LsenKeyON - LsenKeyOFF;
  ColorNumR = RsenKeyON - RsenKeyOFF;
 }

void LeftMove ()
 {
   LEDR(1);
   Move(CW,CW,150,150);
   delay_ms(100);

   while (!SEN1)
     {

           if  ( SEN24 )           Move(CCW,CW,250,50);
      else if  ( SEN23 )           Move(CCW,CW,255,170);
      else if  ( SEN22 )           Move(CCW,CW,200,255);
      else if  ( SEN21 )           Move(CCW,CW,140,255);
      else if  ( SEN20 )           Move(CCW,CW,80,255);
      else if  ( SEN19 )           Move(CCW,CW,40,255);
      else if  ( SEN18 )           Move(CW,CW,0,255);
      else if  ( SEN17 )           Move(CW,CW,60,250);
      else if  ( SEN16 )           Move(CW,CW,120,255);
      else if  ( SEN15 )           Move(CW,CW,140,220);
      else if  ( SEN14 )           Move(CW,CW,140,180);
      else if  ( SEN13 )           Move(CW,CW,140,160);
      else if  ( SEN12 )           Move(CW,CW,160,140);
      else if  ( SEN12 && SEN13 )  Move(CW,CW,140,140);

     }

     LEDR(0);
 }
void RightMove()
 {
   LEDR(1);
   Move(CW,CW,150,150);
   delay_ms(100);

   while (!SEN24)
     {

           if  ( SEN1 )           Move(CW,CCW,50,250);
      else if  ( SEN2 )           Move(CW,CCW,170,255);
      else if  ( SEN3 )           Move(CW,CCW,255,200);
      else if  ( SEN4 )           Move(CW,CCW,255,140);
      else if  ( SEN5 )           Move(CW,CCW,255,80);
      else if  ( SEN6 )           Move(CW,CCW,255,40);
      else if  ( SEN7 )           Move(CW,CW,255,0);
      else if  ( SEN8 )           Move(CW,CW,250,60);
      else if  ( SEN9 )           Move(CW,CW,255,120);
      else if  ( SEN10 )          Move(CW,CW,220,140);
      else if  ( SEN11 )          Move(CW,CW,180,140);
      else if  ( SEN12 )          Move(CW,CW,160,140);
      else if  ( SEN13 )          Move(CW,CW,140,160);
      else if  ( SEN12 && SEN13 ) Move(CW,CW,140,140);

     }

     LEDR(0);
 }

void Distinction()
 {

  Color();

  if      (!SWG ){ }
  else if ( SWG )
  {
        if ( ColorNumL ==  ColorCalL    ) LeftMove();
   else if ( ColorNumL == (ColorCalL+1) ) LeftMove();
   else if ( ColorNumL == (ColorCalL+2) ) LeftMove();
   else if ( ColorNumL == (ColorCalL+3) ) LeftMove();
   else if ( ColorNumL == (ColorCalL-1) ) LeftMove();
   else if ( ColorNumL == (ColorCalL-2) ) LeftMove();
   else if ( ColorNumL == (ColorCalL-3) ) LeftMove();

   else if ( ColorNumR ==  ColorCalR    ) RightMove();
   else if ( ColorNumR == (ColorCalR+1) ) RightMove();
   else if ( ColorNumR == (ColorCalR+2) ) RightMove();
   else if ( ColorNumR == (ColorCalR+3) ) RightMove();
   else if ( ColorNumR == (ColorCalR-1) ) RightMove();
   else if ( ColorNumR == (ColorCalR-2) ) RightMove();
   else if ( ColorNumR == (ColorCalR-3) ) RightMove();
   // else LineFollower();
  }

 }

void ReadSen ()
{
 if ( SEN1 ) RS|=0b000000000000000000000001;
 if ( SEN2 ) RS|=0b000000000000000000000010;
 if ( SEN3 ) RS|=0b000000000000000000000100;
 if ( SEN4 ) RS|=0b000000000000000000001000;
 if ( SEN5 ) RS|=0b000000000000000000010000;
 if ( SEN6 ) RS|=0b000000000000000000100000;
 if ( SEN7 ) RS|=0b000000000000000001000000;
 if ( SEN8 ) RS|=0b000000000000000010000000;
 if ( SEN9 ) RS|=0b000000000000000100000000;
 if ( SEN10) RS|=0b000000000000001000000000;
 if ( SEN11) RS|=0b000000000000010000000000;
 if ( SEN12) RS|=0b000000000000100000000000;
 if ( SEN13) RS|=0b000000000001000000000000;
 if ( SEN14) RS|=0b000000000010000000000000;
 if ( SEN15) RS|=0b000000000100000000000000;
 if ( SEN16) RS|=0b000000001000000000000000;
 if ( SEN17) RS|=0b000000010000000000000000;
 if ( SEN18) RS|=0b000000100000000000000000;
 if ( SEN19) RS|=0b000001000000000000000000;
 if ( SEN20) RS|=0b000010000000000000000000;
 if ( SEN21) RS|=0b000100000000000000000000;
 if ( SEN22) RS|=0b001000000000000000000000;
 if ( SEN23) RS|=0b010000000000000000000000;
 if ( SEN24) RS|=0b100000000000000000000000;
}

void LineFollowerRGB ()
 {
  V = VolomADC;

  if ( SEN12 || SEN13 )
  {
   ReadSen();

   if ( (RS == 0b000000000001100000000000) ||
        (RS == 0b000000000001000000000000) ||
        (RS == 0b000000000000100000000000)
      )
      {
       Distinction();

            if  ( SEN12 && SEN13 )  Move(CW,CW,V,V);
       else if  ( SEN12 )           Move(CW,CW,20+V,V);
       else if  ( SEN13 )           Move(CW,CW,V,20+V);
      }

   else
      {
            if  ( SEN12 && SEN13 )  Move(CW,CW,V,V);
       else if  ( SEN12 )           Move(CW,CW,20+V,V);
       else if  ( SEN13 )           Move(CW,CW,V,20+V);
      }


  }

  else if  ( SEN11 )           Move(CW,CW,40+V,V);
  else if  ( SEN14 )           Move(CW,CW,V,40+V);

  else if  ( SEN10 )           Move(CW,CW,60+V,V);
  else if  ( SEN15 )           Move(CW,CW,V,60+V);

  else if  ( SEN9 )            Move(CW,CW,80+V,V);
  else if  ( SEN16 )           Move(CW,CW,V,80+V);

  else if  ( SEN8 )            Move(CW,CW,100+V,V);
  else if  ( SEN17 )           Move(CW,CW,V,100+V);
//-----------------------------------------------------------
  else if  ( SEN7 )            Move(CW,CW,150,0);
  else if  ( SEN18 )           Move(CW,CW,0,150);

  else if  ( SEN6 )            Move(CW,CW,250,0);
  else if  ( SEN19 )           Move(CW,CW,0,250);

  else if  ( SEN5 )            Move(CW,CCW,200,100);
  else if  ( SEN20 )           Move(CCW,CW,190,200);

  else if  ( SEN4 )            Move(CW,CCW,190,190);
  else if  ( SEN21 )           Move(CCW,CW,190,190);

  else if  ( SEN3 )            Move(CW,CCW,190,255);
  else if  ( SEN22 )           Move(CCW,CW,255,190);

  else if  ( SEN2 )            Move(CW,CCW,100,255);
  else if  ( SEN23 )           Move(CCW,CW,255,100);

  else if  ( SEN1 )            Move(CW,CCW,50,255);
  else if  ( SEN24 )           Move(CCW,CW,255,50);

 // else Move(CW,CW,0,0);
 }

void LineFollower ()
 {
  V = VolomADC;

  //ReadSen();

//
//  if ( SEN7 && SEN8 &&  SEN11 && SEN12 && SEN13 && SEN14 && SEN15 && SEN16 && SEN17 && SEN18 )
//  {
//   i=!i;
//  }
//       if ( i==1 ) {LEDY(1);}
//  else if ( i==0 ) {LEDY(0);}

if (  p== 0 )
{
       if  ( SEN12 && SEN13 )  {Move(CW,CW,V,V);}
  else if  ( SEN12 )           {Move(CW,CW,20+V,V);}
  else if  ( SEN13 )           {Move(CW,CW,V,20+V);}

  else if  ( SEN11 )           {Move(CW,CW,40+V,V);}
  else if  ( SEN14 )           {Move(CW,CW,V,40+V);}

  //else if  ( SEN10 )              Move(CW,CW,60+V,V);
  else if  ( i == 0 ) {if ( SEN10  ) {Move(CW,CW,60+V,V);}}
  else if  ( i == 1 ) {if ( SEN10N ) {Move(CW,CW,60+V,V);}}
  else if  ( SEN15 )                {Move(CW,CW,V,60+V);}   
  p=1;
}
 if ( p==1 )
 {
 // else if  ( SEN9 )               Move(CW,CW,80+V,V);
   if  ( i == 0 ) if ( SEN9  )  {Move(CW,CW,80+V,V);}
  else if  ( i == 1 ) if ( SEN9N )  {Move(CW,CW,80+V,V);}
  else if  ( SEN16 )                {Move(CW,CW,V,80+V);}

  else if  ( SEN8 )            {Move(CW,CW,100+V,V);}
  else if  ( SEN17 )           {Move(CW,CW,V,100+V);}

  else if  ( SEN7 )            {Move(CW,CW,150,0);}
  else if  ( SEN18 )           {Move(CW,CW,0,150);} 
  p=2;
  }                               
  if ( p==2 )
  {
   if  ( SEN6 )                 {Move(CW,CW,250,0);}
  //else if  ( SEN19 )              Move(CW,CW,0,250);
  else if  ( i == 0 ){ if ( SEN19  ) {Move(CW,CW,0,250);}}
  else if  ( i == 1 ){ if ( SEN19N ) {Move(CW,CW,0,250);}}

  else if  ( SEN5 )            {Move(CW,CCW,200,100);}
  else if  ( SEN20 )           {Move(CCW,CW,190,200);}

  else if  ( SEN4 )            {Move(CW,CCW,190,190);}
  else if  ( SEN21 )           {Move(CCW,CW,190,190);}
 p=3;
 }
  if ( p==3 )
  {
   if  ( SEN3 )            {Move(CW,CCW,190,255);}
  else if  ( SEN22 )           {Move(CCW,CW,255,190);}

  else if  ( SEN2 )            {Move(CW,CCW,100,255);}
  else if  ( SEN23 )           {Move(CCW,CW,255,100);}

  else if  ( SEN1 )            {Move(CW,CCW,50,255);}
  else if  ( SEN24 )           {Move(CCW,CW,255,50);}
  p=0;
  }
 // else {Move(CW,CW,0,0);}
 }

void main(void)
{

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
// Port B initialization
// Function: Bit7=In Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=out
DDRB=(0<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=T
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
// Port E initialization
// Function: Bit7=Out Bit6=out Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out
DDRE=(1<<DDE7) | (1<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (1<<DDE0);
// State: Bit7=0 Bit6=P Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=0
PORTE=(0<<PORTE7) | (1<<PORTE6) | (1<<PORTE5) | (1<<PORTE4) | (1<<PORTE3) | (1<<PORTE2) | (1<<PORTE1) | (0<<PORTE0);
// Port F initialization
// Function: Bit7=Out Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=Out Bit1=Out Bit0=Out
DDRF=(1<<DDF7) | (0<<DDF6) | (0<<DDF5) | (1<<DDF4) | (0<<DDF3) | (1<<DDF2) | (1<<DDF1) | (1<<DDF0);
// State: Bit7=0 Bit6=T Bit5=T Bit4=0 Bit3=T Bit2=0 Bit1=0 Bit0=0
PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
// Port G initialization
// Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
// State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 62/500 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// Timer Period: 4/096 ms
ASSR=0<<AS0;
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (1<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// OC1C output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 62/500 kHz
// Mode: Normal top=0xFF
// OC2 output: Disconnected
// Timer Period: 4/096 ms
TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (1<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer3 Stopped
// Mode: Normal top=0xFFFF
// OC3A output: Disconnected
// OC3B output: Disconnected
// OC3C output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);

// USART0 initialization
// USART0 disabled
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);

// USART1 initialization
// USART1 disabled
UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 1000/000 kHz
// ADC Voltage Reference: AREF pin
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
SFIOR=(0<<ACME);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTB Bit 6
// RD - PORTB Bit 5
// EN - PORTB Bit 4
// D4 - PORTB Bit 3
// D5 - PORTB Bit 2
// D6 - PORTB Bit 1
// D7 - PORTE Bit 7
// Characters/line: 8
lcd_init(8);

// Global enable interrupts
#asm("sei")
while (1)
      {
       
        if ( !SWR )
        {
         lcd_clear();
         LEDG(1);

         while (1) {LineFollower();}
        }
        if ( !SWL )
        {

         LEDY(1);

         lcd_clear();
         lcd_gotoxy(0,0);
         lcd_puts("SWR= CalR");
         lcd_gotoxy(0,1);
         lcd_puts("SWL= CalL");


         if ( !SWR )
         {
         CalR();

         lcd_clear();

         LEDG(1);
         delay_ms(100);
         LEDG(0);

         // while (1) LineFollowerRGB();
         }

         if ( !SWL )
         {
         CalL();

         lcd_clear();

         LEDG(1);
         delay_ms(100);
         LEDG(0);

          //  while (1) LineFollowerRGB();
         }
         if ( !SWM ) while (1) LineFollowerRGB();

        } 
        
        } 
        
}




