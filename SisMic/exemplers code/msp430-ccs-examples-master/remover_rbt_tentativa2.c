#include <msp430.h>

void debounce();
int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer

	//CONFIG.
    P1DIR |= BIT0;
    P2DIR &= ~BIT1;
    P2REN |= BIT1;
    P2OUT |= BIT1;

    debounce();

    return 0;
}

void debounce(){
volatile int i;

    while(1){
    if((P2IN & BIT1)==0){
    for(i = 10000;i>1;i--){
    P1OUT ^= BIT0;
   }
  }

 }
}
