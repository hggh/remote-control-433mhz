#include "Arduino.h"
#include <avr/power.h>
#include <RFM69.h>
#include <JeeLib.h>
#include <Bounce2.h>

#include "config.h"

#define BUTTON_COUNT 6

RFM69 radio;
byte ADCSRA_status;
const uint8_t BUTTON_PINS[BUTTON_COUNT] = {A0, A1, A2, A3, A4, A5};
Bounce * buttons = new Bounce[BUTTON_COUNT];
const float InternalReferenceVoltage = 1.1;
volatile short do_sleep = 1;
volatile short button_pressed = 10;
volatile short runs = 0;

ISR(WDT_vect) {
	Sleepy::watchdogEvent();
}

float read_battery_volatage() {
	power_adc_enable();
	ADCSRA = ADCSRA_status;
	ADCSRA |= bit (ADPS0) |  bit (ADPS1) | bit (ADPS2);  // Prescaler of 128
	ADMUX = bit (REFS0) | bit (MUX3) | bit (MUX2) | bit (MUX1);

	delay(10);
	bitSet (ADCSRA, ADSC);
	while (bit_is_set(ADCSRA, ADSC)) {
	}
	float battery_voltage = InternalReferenceVoltage / float (ADC + 0.5) * 1024.0;

	ADCSRA &= ~(1 << 7);
	power_adc_disable();
	return battery_voltage;
}


void setup_interrupts() {
	noInterrupts();
	PCICR |= (1 << PCIE1);

	PCMSK1 |= (1<<PCINT8);
	PCMSK1 |= (1<<PCINT9);
	PCMSK1 |= (1<<PCINT10);
	PCMSK1 |= (1<<PCINT11);
	PCMSK1 |= (1<<PCINT12);
	PCMSK1 |= (1<<PCINT13);

	interrupts();
}

void disable_pin_change_interrupt() {
	noInterrupts();

	PCICR &= ~(1 << PCIE1);
	PCMSK1 &= ~(1<<PCINT8);
	PCMSK1 &= ~(1<<PCINT9);
	PCMSK1 &= ~(1<<PCINT10);
	PCMSK1 &= ~(1<<PCINT11);
	PCMSK1 &= ~(1<<PCINT12);
	PCMSK1 &= ~(1<<PCINT13);

	interrupts();
}

ISR(PCINT1_vect) {
	do_sleep = 0;
	disable_pin_change_interrupt();
}


void setup() {
	ADCSRA_status = ADCSRA;
	ADCSRA &= ~(1 << 7);
	power_adc_disable();
	power_twi_disable();
	power_usart0_disable();

	for (uint8_t i = 0; i < BUTTON_COUNT; i++) {
		buttons[i].attach(BUTTON_PINS[i], INPUT);
		buttons[i].interval(50);
	}

	setup_interrupts();

	radio.initialize(FREQUENCY, NODEID, NETWORKID);
	radio.encrypt(ENCRYPTKEY);
	radio.sleep();
}

void loop() {
	for (uint8_t i = 0; i < BUTTON_COUNT; i++) {
		buttons[i].update();
		if (buttons[i].rose()) {
			button_pressed = i;
		}
	}
	if (button_pressed != 10) {
		char buffer[40] = "";
		double volt = (double)read_battery_volatage();
		char volt_str[10];
		dtostrf(volt, 3,2, volt_str);

		sprintf(buffer, "%d;RC;%d:%lu;%s", NODEID, button_pressed, millis(), volt_str);
		radio.sendWithRetry(GATEWAYID, buffer, strlen(buffer), 3, 50);
		radio.sleep();

		do_sleep = 1;
	}
	if (do_sleep == 1) {
		button_pressed = 10;
		runs = 0;
		setup_interrupts();
		radio.sleep();
		Sleepy::powerDown();
	}
	else {
		delay(0.5);
		runs++;

		// we did not send any stuff, but alive for 60ms to force sleep again
		if (runs > 300) {
			do_sleep = 1;
		}
	}
}
