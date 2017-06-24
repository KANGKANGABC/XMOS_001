/*
 * Motor.xc

 *
 *  Created on: 2017Äê2ÔÂ25ÈÕ
 *      Author: ZHAOKANG
 */

#include <motor.h>
#include <delay.h>
#include <uart.h>
#include <xs1.h>
#include <debug_print.h>
#include <platform.h>
#include <stdio.h>

port UartTx = XS1_PORT_1F;

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
    // CRC-CCITT = X16 + X12 + X5 + X0

unsigned long Table_CRC[256];


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

unsigned short CRC16( unsigned char * aData, unsigned long aSize )
{
    unsigned long  i;
    unsigned short nAccum = 0;

    BuildTable16( cnCRC_16 ); //  or cnCRC_CCITT
    for ( i = 0; i < aSize; i++ )
        nAccum = ( nAccum << 8 ) ^ ( unsigned short )Table_CRC[( nAccum >> 8 ) ^ *aData++];
    return nAccum;
}

void ClockWise1(int ID,int angle)
{
    u8 CRC_L,CRC_H;
    int crc1;
    int buf2;
    if(angle > 1024)
        angle = 1024;
    if(angle < 1)
        angle = 1;
    //printf("%d \n",angle);

    buf2=angle;
    angle_H=(u8)(buf2>>8);
    angle_L=(u8)buf2;

    InitUartTx(UartTx);

    //DelayUs(10000);
    Uart_Send_Byte(UartTx,0xFF);
    buf[0] = 0xFF;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0xFF);
    buf[1] = 0xFF;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0xFD);
    buf[2] = 0xFD;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0x00);
    buf[3] = 0x00;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,ID);
    buf[4] = ID;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0x07);
    buf[5] = 0x07;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0x00);
    buf[6] = 0x00;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0x03);
    buf[7] = 0x03;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0x1E);
    buf[8] = 0x1E;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0x00);
    buf[9] = 0x00;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,angle_L);
    buf[10] = angle_L;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,angle_H);
    buf[11] = angle_H;
    //DelayUs(100);

    crc1 = CRC16(buf,12);
    CRC_L = (crc1 & 0x00FF);
    CRC_H = (crc1>>8) & 0x00FF;
    Uart_Send_Byte(UartTx,CRC_L);
    //DelayUs(100);
    Uart_Send_Byte(UartTx,CRC_H);
    //DelayUs(100);

    //DelayUs(10000);


}
void ClockWise(int ID,int angle)
{
    u8 CRC_L,CRC_H;
    int crc1;
    int buf2;

    buf2=angle;
    angle_H=(u8)(buf2>>8);
    angle_L=(u8)buf2;

    InitUartTx(UartTx);

    DelayUs(10000);
    Uart_Send_Byte(UartTx,0xFF);
    buf[0] = 0xFF;
    DelayUs(100);
    Uart_Send_Byte(UartTx,0xFF);
    buf[1] = 0xFF;
    DelayUs(100);
    Uart_Send_Byte(UartTx,0xFD);
    buf[2] = 0xFD;
    DelayUs(100);
    Uart_Send_Byte(UartTx,0x00);
    buf[3] = 0x00;
    DelayUs(100);
    Uart_Send_Byte(UartTx,ID);
    buf[4] = ID;
    DelayUs(100);
    Uart_Send_Byte(UartTx,0x07);
    buf[5] = 0x07;
    DelayUs(100);
    Uart_Send_Byte(UartTx,0x00);
    buf[6] = 0x00;
    DelayUs(100);
    Uart_Send_Byte(UartTx,0x03);
    buf[7] = 0x03;
    DelayUs(100);
    Uart_Send_Byte(UartTx,0x1E);
    buf[8] = 0x1E;
    DelayUs(100);
    Uart_Send_Byte(UartTx,0x00);
    buf[9] = 0x00;
    DelayUs(100);
    Uart_Send_Byte(UartTx,angle_L);
    buf[10] = angle_L;
    DelayUs(100);
    Uart_Send_Byte(UartTx,angle_H);
    buf[11] = angle_H;
    DelayUs(100);

    crc1 = CRC16(buf,12);
    CRC_L = (crc1 & 0x00FF);
    CRC_H = (crc1>>8) & 0x00FF;
    Uart_Send_Byte(UartTx,CRC_L);
    DelayUs(100);
    Uart_Send_Byte(UartTx,CRC_H);
    DelayUs(100);

    DelayUs(10000);


}
void Led(int ID,int color)
{
    u8 CRC_L,CRC_H;
    int crc1;
    int buf2;
    angle_H=(u8)(buf2>>8);
    angle_L=(u8)buf2;

    InitUartTx(UartTx);
    Uart_Send_Byte(UartTx,0x00);
    //DelayUs(10000);
    Uart_Send_Byte(UartTx,0xFF);
    buf[0] = 0xFF;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0xFF);
    buf[1] = 0xFF;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0xFD);
    buf[2] = 0xFD;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0x00);
    buf[3] = 0x00;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,ID);
    buf[4] = ID;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0x07);
    buf[5] = 0x07;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0x00);
    buf[6] = 0x00;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0x03);
    buf[7] = 0x03;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0x19);
    buf[8] = 0x19;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0x00);
    buf[9] = 0x00;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,color);
    buf[10] = color;
    //DelayUs(100);
    Uart_Send_Byte(UartTx,0x00);
    buf[11] = 0x00;
    //DelayUs(100);

    crc1 = CRC16(buf,12);
    CRC_L = (crc1 & 0x00FF);
    CRC_H = (crc1>>8) & 0x00FF;
    Uart_Send_Byte(UartTx,CRC_L);
    //DelayUs(100);
    Uart_Send_Byte(UartTx,CRC_H);
    //DelayUs(100);

    //DelayUs(10000);


}
void Read_Degree(void)
{
    u8 CRC_L,CRC_H;
    unsigned char tmp,i;
    unsigned char RecBuf[14];
    int crc1;

    InitUartTx(UartTx);
    Uart_Send_Byte(UartTx,0x00);
    Uart_Send_Byte(UartTx,0xFF);
    buf[0] = 0xFF;
    Uart_Send_Byte(UartTx,0xFF);
    buf[1] = 0xFF;
    Uart_Send_Byte(UartTx,0xFD);
    buf[2] = 0xFD;
    Uart_Send_Byte(UartTx,0x00);
    buf[3] = 0x00;
    Uart_Send_Byte(UartTx,0x01);
    buf[4] = 0x01;
    Uart_Send_Byte(UartTx,0x07);
    buf[5] = 0x07;
    Uart_Send_Byte(UartTx,0x00);
    buf[6] = 0x00;
    Uart_Send_Byte(UartTx,0x02);
    buf[7] = 0x02;
    Uart_Send_Byte(UartTx,0x08);
    buf[8] = 0x08;
    Uart_Send_Byte(UartTx,0x00);
    buf[9] = 0x00;
    Uart_Send_Byte(UartTx,0x02);
    buf[10] = 0x02;
    Uart_Send_Byte(UartTx,0x00);
    buf[11] = 0x00;

    crc1 = CRC16(buf,12);
    CRC_L = (crc1 & 0x00FF);
    CRC_H = (crc1>>8) & 0x00FF;
    Uart_Send_Byte(UartTx,CRC_L);
    Uart_Send_Byte(UartTx,CRC_H);
    printf("%d\n",CRC_L);

    InitUartRx(UartTx);
    DelayUs(10);
    i = 0;
    while(1)
    {
        tmp = Uart_Receive_Byte(UartTx);
        printf("!!!\n");
        RecBuf[i ++] = tmp;
        if(i > 10)
            break;
    }
    printf("%d %d\n",RecBuf[9],RecBuf[10]);






}
void Motor_app(chanend streaming c1,chanend streaming c2,chanend streaming c3,chanend streaming c4,chanend streaming c5,chanend streaming c6,chanend c7,chanend c8) {

    int m1_degree,m2_degree,m3_degree,m4_degree,m5_degree,m6_degree,
    SelectId,SelectPosition,m1_degree_pre = 500,m2_degree_pre = 500,m3_degree_pre = 500
    ,m4_degree_pre = 500,m5_degree_pre = 500,m6_degree_pre = 500,count;
    InitUartTx(UartTx);
    while(1)
    {
        select{
            case c1:> m1_degree:
                break;
            case c2:> m2_degree:
                break;
            case c3:> m3_degree:
                break;
            case c4:> m4_degree:
                break;
            case c5:> m5_degree:
                break;
            case c6:> m6_degree:
                break;
            case c7:> SelectId:
                Led(0xFE,0x01);
                Led(0xFE,0x01);
                Led(0xFE,0x01);
                break;
            case c8:> SelectPosition:
                break;
            default:
                //printf("ReadyToGo!  %d.%d\n", x_int,y_int);
//                ClockWise1(0x01,m1_degree);
//                ClockWise1(0x02,m2_degree);
//                ClockWise1(0x03,m3_degree);
//                ClockWise1(0x04,m4_degree);
//                ClockWise1(0x05,m5_degree);
//                ClockWise1(0x06,m6_degree);
                Led(SelectId,0x02);
                switch(SelectId){
                    case 0x01:
                        for(count = 1;count < 11;count ++)
                        {
                            ClockWise1(SelectId,m1_degree_pre + (SelectPosition - m1_degree_pre)*count/10);
                        }
                        m1_degree_pre = SelectPosition;
                        break;
                    case 0x02:
                        for(count = 1;count < 11;count ++)
                        {
                            ClockWise1(SelectId,m2_degree_pre + (SelectPosition - m2_degree_pre)*count/10);
                        }
                        m2_degree_pre = SelectPosition;
                        break;
                    case 0x03:
                        for(count = 1;count < 11;count ++)
                        {
                            ClockWise1(SelectId,m3_degree_pre + (SelectPosition - m3_degree_pre)*count/10);
                        }
                        m3_degree_pre = SelectPosition;
                        break;
                    case 0x04:
                        for(count = 1;count < 11;count ++)
                        {
                            ClockWise1(SelectId,m4_degree_pre + (SelectPosition - m4_degree_pre)*count/10);
                        }
                        m4_degree_pre = SelectPosition;
                        break;
                    case 0x05:
                        for(count = 1;count < 11;count ++)
                        {
                            ClockWise1(SelectId,m5_degree_pre + (SelectPosition - m5_degree_pre)*count/10);
                        }
                        m5_degree_pre = SelectPosition;
                        break;
                    case 0x06:
                        for(count = 1;count < 11;count ++)
                        {
                            ClockWise1(SelectId,m6_degree_pre + (SelectPosition - m6_degree_pre)*count/10);
                        }
                        m6_degree_pre = SelectPosition;
                        break;
                    default:
                        break;
                }

                //printf("\n");
                //DelayMs(1);

                break;
        }

    }

}
