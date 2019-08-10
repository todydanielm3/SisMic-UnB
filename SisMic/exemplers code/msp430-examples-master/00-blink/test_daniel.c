/*
--------------------------------------------------------------------
                         KOD
--------------------------------------------------------------------
*/

#include <intrinsics.h>
#include <stdint.h>
#include <msp430.h>

#define trig_pin BIT1     // P6.1
#define echo_pin BIT3     // P1.3
#define led_pin BIT0     // P1.0
#define mesafe_esigi 26// cm
#define distancia_max 2048   // ~250 ms

void trigyapma() {
 // trigger Baslat
 P6OUT |= trig_pin;

  // Yüksek trig ile zaman küçük bir miktar bekleyin> 10us gerekli (~ 1 MHz MCLK 10 saat döngüsü)
 __delay_cycles(10);

  // trigger sonlandır
 P6OUT &= ~trig_pin;
}

int main(void) {
 WDTCTL = WDTPW | WDTHOLD;

  //Low başlatmak için trig pinini yapılandırdık.
 P6DIR |= trig_pin;
 P6OUT &= ~trig_pin;

  // LED i yapılandırdık.
 P1DIR |= led_pin;
 P1OUT &= ~led_pin;

  // echo pinini yapılandırmak için TA0CCR2 yakalama girişi olarak ayarladık.
 P1DIR &= ~echo_pin;
 P1SEL |= echo_pin;

  // TAO kurduk,P1.3
 TA0CCTL2 = CM_3 | CCIS_0 | SCS | CAP | CCIE;

  // TA0 CCR0 (ölçü aralığı) karşılaştırmak için kurduk
 TA0CCR0 = distancia_max;
 TA0CCTL0 = CCIE;

  // TAO kuruldu ACLK / 4 = 8192 Hz ile
 TA0CTL = TASSEL__ACLK | ID__4 | MC__CONTINUOUS | TACLR;

  uint16_t lastCount = 0;
 uint32_t distance = 0;

  for (;;)
 {
  trigyapma();

   // echo startı başlattık
  __low_power_mode_3();

   lastCount = TA0CCR2;

   // echo sonunu bekledik
  __low_power_mode_3();

   distance = TA0CCR2 - lastCount;
  distance *= 34000;
  distance >>= 14;  // bölüm 16384 (2 ^ 14)

   if (distance <= mesafe_esigi)
  {
   // led yak
   P1OUT |= led_pin;
  }
  else
  {
   //led sondur
   P1OUT &= ~led_pin;
  }

   // trig bekleme
  __low_power_mode_3();
 }
}

#pragma vector = TIMER0_A0_VECTOR
__interrupt void TIMER0_A0_ISR (void) {
 // tik aralığını ölçün
 __low_power_mode_off_on_exit();
 TA0CCR0 += distancia_max;
}

#pragma vector = TIMER0_A1_VECTOR
__interrupt void TIMER0_A1_ISR (void) {
 // yankı pinin durumu
 __low_power_mode_off_on_exit();
 TA0IV = 0;
}
