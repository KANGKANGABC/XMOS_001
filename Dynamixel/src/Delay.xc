/*
 * Delay.xc

 *
 *  Created on: 2017��2��25��
 *      Author: ZHAOKANG
 */
#include"delay.h"
#include <xs1.h>

void DelayMs(unsigned ms)
{
    for(int i=0;i<ms;i++)
    {
        DelayUs(1000);
    }
}

void DelayUs(unsigned us)
{
    unsigned time;
    timer t;//����һ����ʱ��

    t:>time;
    for(int i=0;i<us;i++)
    {
        time +=100;
        t when timerafter(time):>void;
    }
}
