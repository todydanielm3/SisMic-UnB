/* Build: msp430-gcc -mmcu=msp430g2231 -g -o us-dist-proto.elf us-dist-proto.c */

#include <msp430g2231.h>

unsigned int up_counter;
unsigned int distance_cm;

/* Timer A0 Capture Interrupt routine
 P1.1 (echo) causes this routine to be called */
#pragma vector=TIMERA0_VECTOR
__interrupt void TimerA0(void)
{
	if (CCTL0 & CCI)			// Raising edge
	{
		up_counter = CCR0;		// Copy counter to variable
	}
	else						// Falling edge
	{
		// Formula: Distance in cm = (Time in uSec)/58
		distance_cm = (CCR0 - up_counter)/58;
	}
	TA0CTL &= ~TAIFG;			// Clear interrupt flag - handled
}

int main(void)
{
	WDTCTL = WDTPW + WDTHOLD;       // Stop Watch Dog Timer

	/* set P1.4 to output direction (trigger) */
	P1DIR |= BIT4;
	P1OUT &= ~BIT4;					// keep trigger at low

    /* Set P1.1 to input direction (echo)
	  Why P1.1? - msp430g2231 datasheet mention this as
	  input for Timer A0 - Compare/Capture input */
	P1DIR &= ~BIT1;
	// Select P1.1 as timer trigger input select (echo from sensor)
	P1SEL = BIT1;

	/* Timer A0 configure to read echo signal:
	Timer A Capture/Compare Control 0 =>
	capture mode: 1 - both edges +
	capture sychronize +
	capture input select 0 => P1.1 (CCI1A) +
    capture mode +
	capture compare interrupt enable */
	CCTL0 |= CM_3 + SCS + CCIS_0 + CAP + CCIE;

	/* Timer A Control configuration =>
	Timer A clock source select: 1 - SMClock +
	Timer A mode control: 2 - Continous up +
	Timer A clock input divider 0 - No divider */
 	TA0CTL |= TASSEL_2 + MC_2 + ID_0;

	// Global Interrupt Enable
	_BIS_SR(GIE);

	for (;;)
	{
		P1OUT ^= BIT4; 				// assert
		__delay_cycles(10);			// 10us wide
		P1OUT ^= BIT4; 				// deassert
		__delay_cycles(60000);		// 60ms measurement cycle
	}
}
