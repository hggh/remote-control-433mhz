#include "Arduino.h"
#include <avr/power.h>
#include <RFM69.h>
#include <JeeLib.h>

#include "config.h"

RFM69 radio;
byte ADCSRA_status;
const float InternalReferenceVoltage = 1.1;

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

void setup() {
	ADCSRA_status = ADCSRA;
	ADCSRA &= ~(1 << 7);
	power_adc_disable();
	power_twi_disable();

	pinMode(A0, INPUT);
	pinMode(A1, INPUT);
	pinMode(A2, INPUT);
	pinMode(A3, INPUT);
	pinMode(A4, INPUT);
	pinMode(A5, INPUT);

	radio.initialize(FREQUENCY, NODEID, NETWORKID);
	radio.encrypt(ENCRYPTKEY);
	radio.sleep();
}

void loop() {
	if (digitalRead(A5) == HIGH) {
		char buffer[30] = "";
		double volt = (double)read_battery_volatage();

		char volt_str[10];
		dtostrf(volt, 3,2, volt_str);

		sprintf(buffer, "%d;RC;%d;%s", NODEID, millis(), volt_str);
		radio.sendWithRetry(GATEWAYID, buffer, strlen(buffer), 6);
		radio.sleep();
	}
}
