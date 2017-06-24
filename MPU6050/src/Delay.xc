/*
 * Delay.xc

 *
 *  Created on: 2017年2月25日
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
    timer t;//调用一个定时器

    t:>time;
    for(int i=0;i<us;i++)
    {
        time +=100;
        t when timerafter(time):>void;
    }
}
