/*
 * Uart.h
 *
 *  Created on: 2017Äê4ÔÂ27ÈÕ
 *      Author: ZHAOKANG
 */


#ifndef UART_H_
#define UART_H_

void InitUartRx(in port uartRx);
void InitUartTx(out port uartTx);
unsigned char Uart_Receive_Byte (in port uartRx);
void Uart_Send_Byte(out port uartTx, unsigned char byte);

#endif /* UART_H_ */
