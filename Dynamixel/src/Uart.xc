#include <xs1.h>
#include <Uart.h>

#define BAUDRATE  115200
#define BIT_TIME   XS1_TIMER_HZ / BAUDRATE
#define DATA_BITS  8

#define TX_BUFFER_SIZE 16
#define RX_BUFFER_SIZE 16



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


void InitUartRx(in port uartRx)
{
    set_port_pull_none(uartRx);
}
void InitUartTx(out port uartTx)
{
    uartTx <: 1;
}

