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
    uartTx <: 0;                       /* ��ʼλ                */
    time += BIT_TIME ;
    t when timerafter ( time ) :> void ;
    for ( int i=0; i < DATA_BITS; i ++) {   /* ����λ���ɵ�λ����λ */
        uartTx <: >> byte;
        time += BIT_TIME ;
        t when timerafter ( time ) :> void ;
    }
    uartTx <: 1;                        /* ֹͣλ              */
    time += BIT_TIME ;
    t when timerafter ( time ) :> void ;
}

unsigned char Uart_Receive_Byte (in port uartRx)
{
    timer t;
    unsigned time;
    unsigned char byte = 0;
    uartRx when pinseq (0) :> void ;           /* �ȴ���ʼλ                                    */
    t :> time ;       time += BIT_TIME /2;                  /* ���Ӱ��λ����ʱʱ�䣬���������뷢�Ͷ˵�ʱ��� �����λ���ܸ�׼ȷ�ز�������                   */
    for ( int i=0; i <DATA_BITS; i ++) {       /* ��������                                       */
        time += BIT_TIME ;
        t when timerafter ( time ) :> void ;
        uartRx :> >> byte;
    }
        time += BIT_TIME ;               /* ����λ                                         */
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

