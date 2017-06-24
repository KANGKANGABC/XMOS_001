/*
 * ArmRobotV1.2.xc
 *
 *  Created on: 2017Äê5ÔÂ7ÈÕ
 *      Author: ZHAOKANG
 */


#include <xs1.h>
#include <platform.h>
#include <stdio.h>
#include <debug_print.h>
#include <delay.h>
#include <uart.h>
#include <motor.h>

out port Led0 = XS1_PORT_1A; //System Status D1
out port Led1 = XS1_PORT_1D;
void fun()
{
    printf("test\n");
    DelayMs(500);
    Led(0x01,0x02);
    DelayMs(500);
    Led(0x01,0x01);
    while(1)
    {
        Read_Degree();

    }


}

int main()
{
    par{
        on tile[0]: fun();
    }

    return 0;

}
