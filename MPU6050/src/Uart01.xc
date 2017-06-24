/*
 * Uart01.xc
 *
 *  Created on: 2017年2月13日
 *      Author: ZHAOKANG
 */
#include <xs1.h>
#include <xscope.h>
#include <platform.h>
#include <stdio.h>
#include <debug_print.h>
#include <uart.h>
#include <uart_half_duplex.h>
#include <delay.h>
#include <Motor.h>
#include <MPU6050.h>

#define BAUDRATE  115200
#define BIT_TIME   XS1_TIMER_HZ / BAUDRATE
#define DATA_BITS  8
#define PWM_freq 1000

#define TX_BUFFER_SIZE 16
#define RX_BUFFER_SIZE 16
port p_uart = on tile[0] : XS1_PORT_1J;




out port Led1 = XS1_PORT_1D;
out port Led0 = XS1_PORT_1A;


port UartRx = XS1_PORT_1E;
port UartTx = XS1_PORT_1F;


unsigned char duty_buf;

void pwm(unsigned int duty, out port pwm_out, chanend c)//
{


    while(1)
    {
        select{
            case c:> duty_buf:
            break;
            default:
            {
                duty = duty_buf*100;
                timer t1;
                unsigned time;
                t1:>time;
                pwm_out <: 1;
                time += 10*duty;
                t1 when timerafter(time):>void;
                pwm_out <: 0;
                time += (100000000/PWM_freq - 10*duty);
                t1 when timerafter(time):>void;
                pwm_out <: 1;
            }
            break;
        }

    }


}



void xscope_user_init(void)
{
    xscope_register(2,
            XSCOPE_CONTINUOUS,"TESTA",XSCOPE_UINT,"mv",
            XSCOPE_CONTINUOUS,"TESTB",XSCOPE_UINT,"mv"
            );

}

void Uart_Send_Byte(out port uartTx, unsigned char byte)
{
    unsigned time;
    timer t;
    t :> time;
    uartTx <: 0;                       /* 开始位                */
    time += BIT_TIME ;
    t when timerafter ( time ) :> void ;
    for ( int i=0; i < DATA_BITS; i ++) {   /* 数据位，由低位到高位 */
        uartTx <: >> byte;
        time += BIT_TIME ;
        t when timerafter ( time ) :> void ;
    }
    uartTx <: 1;                        /* 停止位              */
    time += BIT_TIME ;
    t when timerafter ( time ) :> void ;
}

unsigned char Uart_Receive_Byte (in port uartRx)
{
    timer t;
    unsigned time;
    unsigned char byte = 0;
    uartRx when pinseq (0) :> void ;           /* 等待开始位                                    */
    t :> time ;       time += BIT_TIME /2;                  /* 增加半个位的延时时间，这样就能与发送端的时序错 开半个位，能更准确地采样数据                   */
    for ( int i=0; i <DATA_BITS; i ++) {       /* 接收数据                                       */
        time += BIT_TIME ;
        t when timerafter ( time ) :> void ;
        uartRx :> >> byte;
    }
        time += BIT_TIME ;               /* 结束位                                         */
        t when timerafter ( time ) :> void ;
    return byte;
}


void InitUart(out port uartTx, in port uartRx)
{
    uartTx <: 1;
    set_port_pull_none(uartRx);
}



void fun2(void)
{
    while(1)
        {
        Led1 <: 1;
        DelayMs(500);
        Led1 <: 0;
        DelayMs(500);
        }
}

void fun3( chanend c)

{
    InitUart(UartTx, UartRx);
    unsigned char tmp;
    xscope_user_init();
    while(1)
    {

        tmp = Uart_Receive_Byte(UartRx);
        Uart_Send_Byte(UartTx, tmp);
        Uart_Send_Byte(UartTx, 0);
        c <: tmp;
        //xscope_int(TESTA,250);
        //xscope_int(TESTB,500);

    }




}

void pwm_one(unsigned int clk, unsigned int duty)
{

    while(1)
    {
        timer t1;
        unsigned time;
        t1:>time;
        Led0 <: 1;
        xscope_int(TESTA,500);
        time += duty;
        t1 when timerafter(time):>void;
        Led0 <: 0;
        xscope_int(TESTA,0);
        time += (clk - duty);
        t1 when timerafter(time):>void;
        Led0 <: 1;
    }




}

struct r_i2c mpu6050 = { XS1_PORT_1O, XS1_PORT_1I };

int main()
{
    chan c;
    chan c1;
    chan c2;
    interface uart_rx_if i_rx;
    interface uart_control_if i_control;
    interface uart_tx_buffered_if i_tx;
    par {
        on tile[0]: InitMPU6050(mpu6050,c1,c2);
        on tile[0]: pwm(1000,Led0,c);
        on tile[0]: fun2();
        on tile[0]: fun3(c);
        on tile[0]: uart_half_duplex(i_tx, i_rx, i_control, null,
        TX_BUFFER_SIZE, RX_BUFFER_SIZE,
        115200, UART_PARITY_NONE, 8, 1, p_uart);
        on tile[0] : Motor_app(i_rx, i_tx, i_control,c1,c2);
    }

    return 0;
}

