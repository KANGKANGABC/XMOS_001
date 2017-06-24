/*
 * Motor.h
 *
 *  Created on: 2017Äê2ÔÂ25ÈÕ
 *      Author: ZHAOKANG
 */


#ifndef MOTOR_H_
#define MOTOR_H_

void Motor_app(client uart_rx_if i_uart_rx,
client uart_tx_buffered_if i_uart_tx,
client uart_control_if i_control,chanend c1,chanend c2);

#endif /* MOTOR_H_ */
