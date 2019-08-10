#include <stdint.h>
#include <msp430.h>
#define distancia_max 2048

void trig();
void config();

__interrupt void TIMER0_A0_ISR();
__interrupt void TIMER0_A1_ISR();


void TIMER0_A1_ISR();

void trig(){//TRIG ---> PINO P4.1
  P4OUT |= BIT1;  //P4.1
  __delay_cycles(10);
  P4OUT &= ~BIT1; //P4.1
}

void config(){

  //trig p4.1
  P4DIR |= BIT1;
  P4OUT &= ~BIT1;

  //led
  P1DIR |= BIT0;
  P1OUT &= ~BIT0;

  //Echo p4.2
  P4DIR &= ~BIT2;
  P4SEL |= ~BIT2;

  TA0CCTL2 = CM_2|CCIS_0|SCS|CAP|CCIE;

  TA0CCR0 = distancia_max;
  TA0CCTL0 = CCIE;

  TA0CTL = TASSEL__ACLK|ID__4|MC__CONTINUOUS|TACLR;
}



int main(void){
  WDTCTL = WDTPW | WDTHOLD;
  config();

    uint32_t lastCount = 0;
    uint16_t distance = 0;

//usar o timer para gera...
    for(;;){
    trig();

/*----------------------------------------------*/
    lastCount = TA0CCR2;

    distance = TA0CCR2 - lastCount;
    distance *= 34000;
    distance >>= 14;

    while(P1IN & BIT1);


    if (distance <= 20){
     P1OUT |= BIT0;
    }

    else{
     P1OUT &= ~BIT0;
    }
/*----------------------------------------------*/
    }




  return 0;
}



#pragma vector=TIMER0_A0_VECTOR
__interrupt void TIMER0_A0_ISR() {
 TA0CCR0 = TA0CCR0 + distancia_max;
}

#pragma vector=TIMER0_A1_VECTOR
__interrupt void TIMER0_A1_ISR() {
 TA0IV = 0; //status do registro interrempe com zero
}
