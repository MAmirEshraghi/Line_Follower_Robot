/*******************************************************
Project : Line Follower Robot with ability of Obstacle Detection
Version : Final
Date    : 05/30/2017
Author  : Mohammad Amir Eshraghi 
Company : www.github.com/MAmirEshraghi/Line_Follower_Robot
Comments: Description and Album available on my GitHub.


Chip type               : ATmega64A
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
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

#define UsKey  PORTB.0
#define UsTrig PORTE.6

//--------------------------------------------------

bit i=0,f2;
int a[23];
int l;
bit DirectionR,DirectionL,b;
unsigned char SpeedR,SpeedL;

unsigned char V;
int RS;
int LsenKeyON,RsenKeyON,LsenKeyOFF,RsenKeyOFF;
unsigned int ColorNumL,ColorNumR,ColorCalL,ColorCalR,c,d;

char m[33];
char str[5];
char gg=0,f=2;
char p,e,j=100,j1;
unsigned int Time_us=0,cunter_ms=0,space_cm=0;
unsigned int cunter_us=0;
unsigned int cunter_ms,cunter_s;

float u = 0.0;
char k;


//--------------------------------------------------


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



interrupt [EXT_INT5] void ext_int5_isr(void)
{
  // Time_us = ((cunter_us*10)+ (cunter_ms*1000) );

      if( (PINE.5==1) )
    {         
    cunter_us=0;
    cunter_ms=0;
    Time_us=0;   
     
    TCNT1H=0xFF60 >> 8;
    TCNT1L=0xFF60 & 0xff; 
         
    f=3;
     
    LEDY(1);
    LEDG(0);
        } 
    else if( (PINE.5==0) )
    {         
         
   // Time_us = ((cunter_us*10) );
    u = ( ( (340) * cunter_us ) / 2000 ) ;     
     
    f=2;  
           
     cunter_us=0; 
     cunter_ms=0;  
     //Time_us=0;      
     
     TCNT1H=0xFF60 >> 8;
     TCNT1L=0xFF60 & 0xff;
     
    LEDY(0);
    LEDG(1);
    
    }

//    Time_us =  (cunter_us) ;    
//    //space_cm=0; 
//  //  space_cm = (17 * Time_us) / 1000 ;
//    space_cm = ( ( (340) * Time_us) / 2000 ) ;     
     
//    cunter_us=0;
//    cunter_ms=0;  
    
}
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer1 value
TCNT1H=0xFF60 >> 8;
TCNT1L=0xFF60 & 0xff;


 //TCNT0=0xF6;       
 cunter_us++;
 //cunter_ms++;

// delay_us(500);
 if ( cunter_us == 500 )
 {
  cunter_us=0;  
  cunter_ms++;
 }
 if ( cunter_ms == 50 )
 { 
 cunter_ms=0;        
 }  
// else LEDR(0);   
// if ( cunter_s == 100 )
// {
//  cunter_s=0;  
// }
 
 }
 



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

// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (1<<ADLAR))

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCH;
}


void Move(char DL,char DR,unsigned char SL,unsigned char SR)
{
    DirectionL=DL;
    DirectionR=DR;
    SpeedL=SL;
    SpeedR=SR;
}

void revolve()
{
 while (!SEN1)    Move(CCW,CW,100,150);

  Move(CW,CW,200,200);
  delay_ms(40);

 while ( !SEN12 )
 {

  for (e=0;e<150;e++)
   {

    Move(CW,CW,(100+e),(70));
    delay_ms(10);
    if           ( (SEN12) || (SEN13) )
    {
     break;
    }
    else if      ( (!SEN12) || (!SEN13) )
    {
     if ( e == 149 )
     {
      e=0;
     }
    }

   }
 break;
 }

}

void space()
{

// if      ( (p==0) && ( 20 < k < 30 ) )
// {  
// p=1;  
// LEDR(1);
// }  
// else if ( (p==1) && (( k > 15) && ( k < 21 )) )
// 
// {
// p=2;
// //LEDR(1);  
// }
//
  
       UsTrig=1;
       delay_us(20);
       UsTrig=0; 
       delay_us(20);    
       
       k=u;
       
  if (  (( k > 5) && ( k < 16 )) )
 { 
  LEDR(1);
  revolve(); 
 } 
 else {LEDR(0);}
}

void LineFollower ()
 {
     i=0;
//  //ReadSen();
//
//  if ( SEN7 && SEN8 &&  SEN11 && SEN12 && SEN13 && SEN14 && SEN15 && SEN16 && SEN17 && SEN18 )
//  {
//   i=!i;
//  }
//       if ( i==1 ) LEDR(1);
//  else if ( i==0 ) LEDR(0);
 /*
 if (p==1){
       if  ( SEN12 && SEN13 )  {Move(CW,CW,V,V);space();}
  else if  ( SEN12 )           {Move(CW,CW,20+V,V);space();}
  else if  ( SEN13 )           {Move(CW,CW,V,20+V);space();}
  }     
  */     
   //else if (p==0){
       if  ( SEN12 && SEN13 )  {Move(CW,CW,V,V);lcd_gotoxy(0,0);lcd_putsf("--");}
  else if  ( SEN12 )           {Move(CW,CW,20+V,V);lcd_gotoxy(0,0);lcd_putsf("12");}
  else if  ( SEN13 )           {Move(CW,CW,V,20+V);lcd_gotoxy(0,0);lcd_putsf("13");}
  //}
  else if  ( SEN11 )           {Move(CW,CW,40+V,V);lcd_gotoxy(0,0);lcd_putsf("11");}
  else if  ( SEN14 )           {Move(CW,CW,V,40+V);lcd_gotoxy(0,0);lcd_putsf("14");}

  //        ( SEN10 )              Move(CW,CW,60+V,V);
  else if  ( i == 0 ) if ( SEN10  ){{Move(CW,CW,60+V,V);lcd_gotoxy(0,0);lcd_putsf("10");}}
  else if  ( i == 1 ) if ( SEN10N ) {Move(CW,CW,60+V,V);}
  else if  ( SEN15 )                {Move(CW,CW,V,60+V);lcd_gotoxy(0,0);lcd_putsf("15");}


  //         ( SEN9 )               Move(CW,CW,80+V,V);
  else if  ( i == 0 ){if ( SEN9  )  {Move(CW,CW,80+V,V);lcd_gotoxy(0,0);lcd_putsf("09");}}
  else if  ( i == 1 ){if ( SEN9N )  {Move(CW,CW,80+V,V);}}
  else if  ( SEN16 )                {Move(CW,CW,V,80+V);lcd_gotoxy(0,0);lcd_putsf("16");}

  else if  ( SEN8 )            {Move(CW,CW,100+V,V);lcd_gotoxy(0,0);lcd_putsf("08");}
  else if  ( SEN17 )           {Move(CW,CW,V,100+V);lcd_gotoxy(0,0);lcd_putsf("17");}

  else if  ( SEN7 )            {Move(CW,CW,150,0);lcd_gotoxy(0,0);lcd_putsf("07");}
  else if  ( SEN18 )           {Move(CW,CW,0,150);lcd_gotoxy(0,0);lcd_putsf("18");}


  else if  ( SEN6 )                 {lcd_gotoxy(0,0);lcd_putsf("06");Move(CW,CW,250,0);}
  //        ( SEN19 )              Move(CW,CW,0,250);
  else if  ( i == 0 ) {if ( SEN19  ){lcd_gotoxy(0,0);lcd_putsf("19");Move(CW,CW,0,250);}}
  else if  ( i == 1 ) {if ( SEN19N ){Move(CW,CW,0,250);}}

  else if  ( SEN5 )            {Move(CW,CCW,200,100);lcd_gotoxy(0,0);lcd_putsf("05");}
  else if  ( SEN20 )           {Move(CCW,CW,190,200);lcd_gotoxy(0,0);lcd_putsf("20");}

  else if  ( SEN4 )            {Move(CW,CCW,190,190);lcd_gotoxy(0,0);lcd_putsf("04");}
  else if  ( SEN21 )           {Move(CCW,CW,190,190);lcd_gotoxy(0,0);lcd_putsf("21");}
  

  else if  ( SEN3 )            {Move(CW,CCW,190,255);lcd_gotoxy(0,0);lcd_putsf("03");}
  else if  ( SEN22 )           {Move(CCW,CW,255,190);lcd_gotoxy(0,0);lcd_putsf("22");}

  else if  ( SEN2 )            {Move(CW,CCW,100,255);lcd_gotoxy(0,0);lcd_putsf("02");}
  else if  ( SEN23 )           {Move(CCW,CW,255,100);lcd_gotoxy(0,0);lcd_putsf("23");}

  else if  ( SEN1 )            {Move(CW,CCW,50,255);lcd_gotoxy(0,0);lcd_putsf("01");}
  else if  ( SEN24 )           {Move(CCW,CW,255,50);lcd_gotoxy(0,0);lcd_putsf("24");}
  
  else {Move(CW,CW,0,0);lcd_clear();}
 }


void choose()
{



 if ( !SWR &&  SWM &&  SWL) {f2=1;delay_ms(20);while(f2==1)
  {
   
   if ( SWR &&  SWM &&  !SWL){lcd_clear();while(1){LineFollower();}}
       
   V = VolomADC;         
      lcd_gotoxy(0,0);
      lcd_putsf("Line Followe");  
      lcd_gotoxy(13,0);
        lcd_putsf("<0>"); 
      lcd_gotoxy(0,1);
       lcd_putsf("speed: +");       
      lcd_gotoxy(0,13);
       itoa(V,str);
       lcd_puts(str);   
       lcd_putsf("%"); 
       
   if(V==9 || V==99)lcd_clear();   
      
   //p=0;LineFollower(); 
                     
   if ( !SWR &&  SWM &&  SWL)f2=0;      //sicktir
  }}   
  
 if (  SWR && !SWM &&  SWL) {f2=1;delay_ms(20);while(f2==1)
  { 
      lcd_gotoxy(0,0);
      lcd_putsf("Color Sensor");   
      lcd_gotoxy(13,0);
        lcd_putsf("<0>"); 
      lcd_gotoxy(0,1);
      lcd_putsf("set=");       
      lcd_gotoxy(0,14);
      itoa(V,str);
      lcd_puts(str);
      if(V==9 || V==99)lcd_clear(); 
      if ( !SWR && SWM &&  SWL)f2=0;      //sicktir
  }}

 if (  SWR &&  SWM && !SWL) {f2=1;delay_ms(20);while(f2==1)
  { 
      lcd_gotoxy(0,0);
      lcd_putsf("UltraSonic");
      lcd_gotoxy(13,0);
        lcd_putsf("<0>"); 
      lcd_gotoxy(0,1);
      lcd_putsf("=");     
      
       UsTrig=1;
       delay_us(20);
       UsTrig=0; 
       delay_us(20); 
              
      lcd_gotoxy(2,1);
      itoa(u,str);
      lcd_puts(str);     
      lcd_putsf("cm");
      
      lcd_gotoxy(6,1);
      lcd_putsf(" set=5~16"); 
      
      
      if(u==9 || u==99)lcd_clear();     
      
      p=1;LineFollower(); 
       
      if ( !SWR &&  SWM &&  SWL)f2=0;      //sicktir
  }}


}

void main(void)
{
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

DDRB=(0<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

DDRE=(1<<DDE7) | (1<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (1<<DDE0);
PORTE=(0<<PORTE7) | (1<<PORTE6) | (1<<PORTE5) | (1<<PORTE4) | (1<<PORTE3) | (1<<PORTE2) | (1<<PORTE1) | (0<<PORTE0);

DDRF=(1<<DDF7) | (0<<DDF6) | (0<<DDF5) | (1<<DDF4) | (0<<DDF3) | (1<<DDF2) | (1<<DDF1) | (1<<DDF0);
PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);

DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 62.500 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// Timer Period: 4.096 ms
ASSR=0<<AS0;
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (1<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;
// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 16000.000 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// OC1C output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0.01 ms
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0xFF;
TCNT1L=0x60;
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
// Clock value: 62.500 kHz
// Mode: Normal top=0xFF
// OC2 output: Disconnected
// Timer Period: 4.096 ms
TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (1<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: 15.625 kHz
// Mode: Normal top=0xFFFF
// OC3A output: Disconnected
// OC3B output: Disconnected
// OC3C output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 4.1943 s
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
TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: On
// INT5 Mode: Any change
// INT6: Off
// INT7: Off
EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (1<<ISC50) | (0<<ISC41) | (0<<ISC40);
EIMSK=(0<<INT7) | (0<<INT6) | (1<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
EIFR=(0<<INTF7) | (0<<INTF6) | (1<<INTF5) | (0<<INTF4) | (0<<INTF3) | (0<<INTF2) | (0<<INTF1) | (0<<INTF0);

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
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AVCC pin
// Only the 8 most significant bits of
// the AD conversion result are used
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
// Characters/line: 16
lcd_init(16);

// Global enable interrupts
#asm("sei")


  j=10;

lcd_gotoxy(0,0);
lcd_putsf("HELP:    o  o  o ");
lcd_gotoxy(0,1);       
lcd_putsf("switchs  ^  ^  ^ ");

delay_ms(1000);
lcd_gotoxy(0,1);       
lcd_putsf("                ");

delay_ms(300);
lcd_gotoxy(0,0);
lcd_putsf("         +  o  o ");

delay_ms(100);
lcd_gotoxy(0,1);       
lcd_putsf(" <-    Back      ");

delay_ms(1000);

lcd_gotoxy(0,0);
lcd_putsf("         o  +  o ");
lcd_gotoxy(0,1);       
lcd_putsf("                 ");

delay_ms(90);
lcd_gotoxy(0,1);       
lcd_putsf("  -    Set   -   ");

delay_ms(1000);

lcd_gotoxy(0,0);
lcd_putsf("         o  o  + ");
lcd_gotoxy(0,1);       
lcd_putsf("                ");

delay_ms(90);
lcd_gotoxy(0,1);       
lcd_putsf("     Start   -> ");

delay_ms(1000);
 


lcd_gotoxy(0,0);
lcd_putsf("   Welcome !    ");
lcd_gotoxy(0,1);       
delay_ms(j);

 j=0;

while (1)
      {
       choose();
               
        for (j=8;j>0;j--)
        { 
               choose();
        lcd_gotoxy(0,0);
        lcd_putsf("Choose:  1  2  3");
        lcd_gotoxy(j,1);       
        lcd_putsf("1: Line Follow"); 
        delay_ms(15);
         if(j==1) {for(j1=0;j1<51;j1++){choose();delay_ms(20);}} //delay_ms(500); 
        lcd_clear();
        }

        for (j=8;j>0;j--)
        { 
               choose();
        lcd_gotoxy(0,0);
        lcd_putsf("Choose:  1  2  3");
        lcd_gotoxy(j,1);       
        lcd_putsf("2: +Color"); 
        delay_ms(15);
        //if(j==1) delay_ms(500);   
         if(j==1) {for(j1=0;j1<51;j1++){choose();delay_ms(20);}}
        lcd_clear();
        }

        for (j=8;j>0;j--)
        { 
               choose();
        lcd_gotoxy(0,0);
        lcd_putsf("Choose:  1  2  3");
        lcd_gotoxy(j,1);       
        lcd_putsf("3: +Obstacle"); 
        delay_ms(15);
        //if(j==1) delay_ms(500); 
         if(j==1) {for(j1=0;j1<51;j1++){choose();delay_ms(20);}}
        lcd_clear();
        }
              
       
      }
}
   /***
   
lcd_gotoxy(0,0);
lcd_putsf("Hi World !");

for (j=16;j>0;j--)
{ 
lcd_gotoxy(0,0);
lcd_putsf("Hi World !");
lcd_gotoxy((j),1);       
lcd_putsf(" i'm RoboNoise."); 
delay_ms(50);
 if(j==1) 
 {
 delay_ms(1500);

 }
lcd_clear();
}
for (j=8;j>0;j--)
{ 
lcd_gotoxy(0,0);
lcd_putsf("Hi World !");
lcd_gotoxy(1,j);       
lcd_putsf("  Welcome "); 
delay_ms(30);
if(j==1) 
 {
 lcd_gotoxy(1,1);       
 lcd_putsf("  Welcome "); 
 delay_ms(200); 
 lcd_gotoxy(1,1);
 lcd_putsf("           "); 
 delay_ms(200);
 lcd_gotoxy(1,1);       
 lcd_putsf("  Welcome "); 
 delay_ms(200); 
 lcd_gotoxy(1,1);
 lcd_putsf("           ");
 delay_ms(200);
 lcd_gotoxy(1,1);       
 lcd_putsf("  Welcome !"); 
 delay_ms(500);  

 }
lcd_clear();
}            

lcd_gotoxy(0,0);
lcd_putsf("Choose  Option  Menu:");
lcd_gotoxy(5,1);
lcd_putsf("    -1-2-3-  ");
delay_ms(1000);
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("Choose:  1  2  3");
delay_ms(100);



------------------------------------------------------------

      if ( !SWL ) 
       {    
           
       delay_us(20); 
       UsTrig=1;
       delay_us(20);
       UsTrig=0; 
       delay_us(20);
      
       k=u;
       LEDG(1);
         //   LineFollower ();
        }
        
      else LEDG(0);
 //     else UsKey=0;
                 
    // Time_us = ((cunter_us*10)+ (cunter_ms*1000) );

//  
       lcd_gotoxy(0,0);       
       lcd_putsf("x:");     
       lcd_gotoxy(4,0); 
       ftoa(u,3,str); 
       lcd_puts(str);     

       lcd_gotoxy(8,0);    
       itoa(Time_us,str);
       lcd_puts(str);
//       if (!SWL )
//       {
//       KeySen=1;
//             }  
//             else KeySen=0;
//             
                     
//       lcd_gotoxy(0,1);    
//       itoa(read_adc(4),str);
//       lcd_puts(str); 
//       
//       lcd_gotoxy(8,1);    
//       itoa((p),str);
//       lcd_puts(str); 
//       
       delay_ms(150);
       lcd_clear();
//       
        
**/