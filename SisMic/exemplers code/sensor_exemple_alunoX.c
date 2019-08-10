#include <msp430.h>
#include "pins.h"
#include "msp_timers.h"

volatile unsigned int time_captured;

void setup_pins() {
    //Setting up P2.1 (B S1 - User input)
    setPin(P2_1, INPUT_PULL_UP);    // Here we've already setup DIR, REN and OUT

    setInterrupt(P2_1, HIGH_TO_LOW); //Enabling and selecting falling border for P2.1 interruptions

    //Setting up P8.2 (Trigger out)
    setPin(P8_2, OUTPUT);           // Here we've already setup DIR, OUT

    //Setting up P1.0 (Red LED - User feedback)
    setPin(P1_0, OUTPUT);            // Here we've already setup DIR, OUT

    //Setting up P4.7 (Green LED - User feedback)
    setPin(P4_7, OUTPUT);            // Here we've already setup DIR, OUT

    //Setting up P2.0 (Echo Listening)
    setPin(P2_0, INPUT_PULL_DOWN);   // Here we've already setup DIR, REN and OUT
    SET_REG(P2SEL, BIT0);                   // Redirecting pin P2.0 to Timer A1 Channel 1

    //---Preset Leds-----
    writePin(P1_0, LOW);
    writePin(P4_7, LOW);
}

void setup_timerA1() {
    TA1CCTL1 = (CAP | CM_3 | CCIE | CCIS_0);     // Setting up Channel 1
    TA1CTL = (TASSEL__SMCLK | TACLR | MC_2); // Setting up Timer A1
}


void set_result(int diff_time) {    // Set the visual output for user
    if (diff_time <= 1160) {        // <= 20 cm
        writePin(P1_0, HIGH);
        writePin(P4_7, LOW);
    }
    else if (diff_time > 1160 && diff_time <= 2320) { // 20 cm < x <= 40 cm
        writePin(P1_0, LOW);
        writePin(P4_7, HIGH);
    }
    else {  // x > 40 cm
        writePin(P1_0, HIGH);
        writePin(P4_7, HIGH);
    }
}

#pragma vector=PORT2_VECTOR
__interrupt void P2ISR() {           // Routine for treating interruptions from P2.1 (B1)
    switch (P2IV) {                  // Reading the Interrupt Vector (P2IV) clears the Interrupt Flag (P2IFG)
    case 0x00: break;       //Nothing changed
    case 0x02: break;       //P2.0
    case 0x04:              //P2.1
        P2IE &= ~(BIT1);    // Disables further interruptions coming from P2.1
        writePin(P8_2, HIGH); // Writing on module Trigger
        delayMicrosseconds(10);      // Wait for 10 microseconds
        writePin(P8_2, LOW);

        setup_timerA1();    // Starts the Timer A1
        break;
    case 0x06: break;       //P2.2
    case 0x08: break;       //P2.3
    case 0x0A: break;       //P2.4
    case 0x0C: break;       //P2.5
    case 0x0E: break;       //P2.6
    default: break;
    }
}

#pragma vector=TIMER1_A1_VECTOR
__interrupt void TA1_CCRN_ISR(){          //Routine for treating interruptions from Timer A1
    switch (TA1IV) {                //Reading the Interrupt Vector (TA1IV) clears the Interrupt Flag (TAIFG)
    case 0x00: break;       //Nothing changed
    case TA1IV_TACCR1:      //TA1CCR1
        if(READ_REG(TA1CCTL1, CCI)){ //Raising edge
            time_captured = TA1CCR1; //Save current time
        }
        else {
            time_captured = TA1CCR1 - time_captured; //Diff between current and previously captured
            set_result(time_captured);               //Toogle the LED's accordingly to the result
            P2IE |= BIT1;                            //Re-Enable P2.1 for interruptions
        }
        break;
    default: break;
    }
}

void main(void) {

  WDTCTL = WDTPW | WDTHOLD;  // Stop Watchdog Timer

  setup_pins();               // Calls routine to setup needed pins

  __enable_interrupt();

  while(1);
}
