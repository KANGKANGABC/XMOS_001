/*
 * Motor.xc

 *
 *  Created on: 2017年2月25日
 *      Author: ZHAOKANG
 */

//#include "Moter.h"
//#include "USART1.h"
#include <delay.h>
#include <uart.h>
#include <uart_half_duplex.h>
#include <xs1.h>
#include <debug_print.h>
#include <platform.h>
#include <stdio.h>

#define u8 unsigned char
u8 Sum=0;
u8 speed_L=0;
u8 speed_H=0;
u8 angle_L=0;
u8 angle_H=0;
u8 buf[16];

const unsigned short cnCRC_16    = 0x8005;
    // CRC-16    = X16 + X15 + X2 + X0
const unsigned short cnCRC_CCITT = 0x1021;
    // CRC-CCITT = X16 + X12 + X5 + X0,???? 16 ? CRC ?????????

unsigned long Table_CRC[256]; // CRC ?

//  ?? 16 ? CRC ?
void BuildTable16( unsigned short aPoly )
{
    unsigned short i, j;
    unsigned short nData;
    unsigned short nAccum;

    for ( i = 0; i < 256; i++ )
    {
        nData = ( unsigned short )( i << 8 );
        nAccum = 0;
        for ( j = 0; j < 8; j++ )
        {
            if ( ( nData ^ nAccum ) & 0x8000 )
                nAccum = ( nAccum << 1 ) ^ aPoly;
            else
                nAccum <<= 1;
            nData <<= 1;
        }
        Table_CRC[i] = ( unsigned long )nAccum;
    }
}

//  ?? 16 ? CRC ?,CRC-16 ? CRC-CCITT
unsigned short CRC16( unsigned char * aData, unsigned long aSize )
{
    unsigned long  i;
    unsigned short nAccum = 0;

    BuildTable16( cnCRC_16 ); //  or cnCRC_CCITT
    for ( i = 0; i < aSize; i++ )
        nAccum = ( nAccum << 8 ) ^ ( unsigned short )Table_CRC[( nAccum >> 8 ) ^ *aData++];
    return nAccum;
}

void ClockWise1(uint16_t ID,uint16_t angle,client uart_rx_if i_uart_rx,
        client uart_tx_buffered_if i_uart_tx,client uart_control_if i_control)
{
    u8 CRC_L,CRC_H;
    uint16_t crc1;
    int buf2;

    buf2=angle;
    angle_H=(u8)(buf2>>8);
    angle_L=(u8)buf2;


    i_control.set_mode(UART_TX_MODE);

    DelayUs(10000);
    i_uart_tx.write(0xFF);
    buf[0] = 0xFF;
    DelayUs(100);
    i_uart_tx.write(0xFF);
    buf[1] = 0xFF;
    DelayUs(100);
    i_uart_tx.write(0xFD);
    buf[2] = 0xFD;
    DelayUs(100);
    i_uart_tx.write(0x00);
    buf[3] = 0x00;
    DelayUs(100);
    i_uart_tx.write(ID);
    buf[4] = ID;
    DelayUs(100);
    i_uart_tx.write(0x07);
    buf[5] = 0x07;
    DelayUs(100);
    i_uart_tx.write(0x00);
    buf[6] = 0x00;
    DelayUs(100);
    i_uart_tx.write(0x03);
    buf[7] = 0x03;
    DelayUs(100);
    i_uart_tx.write(0x1E);
    buf[8] = 0x1E;
    DelayUs(100);
    i_uart_tx.write(0x00);
    buf[9] = 0x00;
    DelayUs(100);
    i_uart_tx.write(angle_L);
    buf[10] = angle_L;
    DelayUs(100);
    i_uart_tx.write(angle_H);
    buf[11] = angle_H;
    DelayUs(100);

    crc1 = CRC16(buf,12);
    CRC_L = (crc1 & 0x00FF);
    CRC_H = (crc1>>8) & 0x00FF;
    i_uart_tx.write(CRC_L);
    DelayUs(100);
    i_uart_tx.write(CRC_H);
    DelayUs(100);

    i_control.set_mode(UART_RX_MODE);
    DelayUs(10000);


}
void ClockWise(uint16_t ID,uint16_t angle,client uart_rx_if i_uart_rx,
        client uart_tx_buffered_if i_uart_tx,client uart_control_if i_control)
{
    u8 CRC_L,CRC_H;
    uint16_t crc1;
    int buf2;

    buf2=angle;
    angle_H=(u8)(buf2>>8);
    angle_L=(u8)buf2;


    i_control.set_mode(UART_TX_MODE);

    DelayUs(10000);
    i_uart_tx.write(0xFF);
    buf[0] = 0xFF;
    DelayUs(100);
    i_uart_tx.write(0xFF);
    buf[1] = 0xFF;
    DelayUs(100);
    i_uart_tx.write(0xFD);
    buf[2] = 0xFD;
    DelayUs(100);
    i_uart_tx.write(0x00);
    buf[3] = 0x00;
    DelayUs(100);
    i_uart_tx.write(ID);
    buf[4] = ID;
    DelayUs(100);
    i_uart_tx.write(0x07);
    buf[5] = 0x07;
    DelayUs(100);
    i_uart_tx.write(0x00);
    buf[6] = 0x00;
    DelayUs(100);
    i_uart_tx.write(0x03);
    buf[7] = 0x03;
    DelayUs(100);
    i_uart_tx.write(0x1E);
    buf[8] = 0x1E;
    DelayUs(100);
    i_uart_tx.write(0x00);
    buf[9] = 0x00;
    DelayUs(100);
    i_uart_tx.write(angle_L);
    buf[10] = angle_L;
    DelayUs(100);
    i_uart_tx.write(angle_H);
    buf[11] = angle_H;
    DelayUs(100);

    crc1 = CRC16(buf,12);
    CRC_L = (crc1 & 0x00FF);
    CRC_H = (crc1>>8) & 0x00FF;
    i_uart_tx.write(CRC_L);
    DelayUs(100);
    i_uart_tx.write(CRC_H);
    DelayUs(100);

    i_control.set_mode(UART_RX_MODE);
    DelayUs(10000);


}
void Motor_app(client uart_rx_if i_uart_rx,
client uart_tx_buffered_if i_uart_tx,
client uart_control_if i_control,chanend c1,chanend c2) {

    int x_int;
    int y_int;
    while(1)
    {


        select{
            case c1:> x_int://待追踪X轴角度，数据同步
                break;
            case c2:> y_int://待追踪y轴角度，数据同步
                break;
            default:
                //i_control.set_mode(UART_RX_MODE);
                //byte = i_uart_rx.read();
                //printf("Great UART!  %d.\n", byte);
                printf("ReadyToGo!  %d.\n", x_int);

                if(x_int>1000)
                    x_int = 1000;
                if(x_int<1)
                    x_int = 1;
                if(y_int>1000)
                    y_int = 1000;
                if(y_int<1)
                    y_int = 1;

                ClockWise(0x01,x_int,i_uart_rx,i_uart_tx,i_control);
                DelayMs(5);
                ClockWise1(0x02,y_int,i_uart_rx,i_uart_tx,i_control);
                DelayMs(5);
                break;
        }




    }

    //i_control.set_mode(UART_TX_MODE);
    //i_uart_tx.write(byte);

}
