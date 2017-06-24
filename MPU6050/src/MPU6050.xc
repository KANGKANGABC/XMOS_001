/*
 * MPU6050.xc
 *
 *  Created on: 2017年2月25日
 *      Author: ZHAOKANG
 */


#include <i2c.h>
#include <MPU6050.h>
#include <math.h>
#include <Delay.h>
#include <xs1.h>
#include <debug_print.h>
#include <platform.h>
#include <stdio.h>



void InitMPU6050(REFERENCE_PARAM(struct r_i2c,i2c),chanend c1,chanend c2)
{
    i2c_master_init(i2c);//I2C Init
    char buf_write[1];//Write Reg



    char data[2];

    float angle_x=1.33;
    float angle_y=1.33;
    float angle_z=1.33;
    float angle_x1=1.33;
    float angle_y1=1.33;
    float angle_z1=1.33;
    short x,y,z;
    char x_h[1],x_l[1],y_h[1],y_l[1],z_h[1],z_l[1];
    char x_G_h[1], x_G_l[1],y_G_h[1], y_G_l[1],z_G_h[1], z_G_l[1];
    char temp[2];
    short temp1;
    double Temperature;

    double xAxis = 0, yAxis = 0, zAxis = 0;
    xAxis = 1;

    unsigned int x_int,y_int,z_int;


    buf_write[0] = 0x00;
    i2c_master_write_reg(MPU6050_ADDRESS,MPU6050_RA_PWR_MGMT_1,buf_write,1,i2c);//
    buf_write[0] = 0x07;
    i2c_master_write_reg(MPU6050_ADDRESS,MPU6050_RA_SMPLRT_DIV,buf_write,1,i2c);//
    buf_write[0] = 0x06;
    i2c_master_write_reg(MPU6050_ADDRESS,MPU6050_RA_CONFIG,buf_write,1,i2c);//
    buf_write[0] = 0x00;
    i2c_master_write_reg(MPU6050_ADDRESS,MPU6050_RA_ACCEL_CONFIG,buf_write,1,i2c);//
    buf_write[0] = 0x18;
    i2c_master_write_reg(MPU6050_ADDRESS,MPU6050_RA_GYRO_CONFIG,buf_write,1,i2c);//





    while(1)
    {
        DelayMs(50);
        i2c_master_read_reg(MPU6050_ADDRESS,0x75,data,1,i2c);

        i2c_master_read_reg(MPU6050_ADDRESS,0x3B,x_h,1,i2c);
        i2c_master_read_reg(MPU6050_ADDRESS,0x3C,x_l,1,i2c);
        i2c_master_read_reg(MPU6050_ADDRESS,0x3D,y_h,1,i2c);
        i2c_master_read_reg(MPU6050_ADDRESS,0x3E,y_l,1,i2c);
        i2c_master_read_reg(MPU6050_ADDRESS,0x3F,z_h,1,i2c);
        i2c_master_read_reg(MPU6050_ADDRESS,0x40,z_l,1,i2c);

        i2c_master_read_reg(MPU6050_ADDRESS,0x43,x_G_h,1,i2c);
        i2c_master_read_reg(MPU6050_ADDRESS,0x44,x_G_l,1,i2c);
        i2c_master_read_reg(MPU6050_ADDRESS,0x45,y_G_h,1,i2c);
        i2c_master_read_reg(MPU6050_ADDRESS,0x46,y_G_l,1,i2c);
        i2c_master_read_reg(MPU6050_ADDRESS,0x47,z_G_h,1,i2c);
        i2c_master_read_reg(MPU6050_ADDRESS,0x48,z_G_l,1,i2c);






        i2c_master_read_reg(MPU6050_ADDRESS,0x41,temp,2,i2c);
        temp1= (temp[0] << 8) | temp[1];

        Temperature = 36.53 + temp1/340;
        printf("Temperature:   %f\n",Temperature);

        xAxis = (x_G_h[0] << 8) | x_G_l[0];
        xAxis = xAxis/16.4;
        yAxis = (y_G_h[0] << 8) | y_G_l[0];
        yAxis = yAxis/16.4;
        zAxis = (z_G_h[0] << 8) | z_G_l[0];
        zAxis = zAxis/16.4;

        x = (x_h[0] << 8) | x_l[0];
        y = (y_h[0] << 8) | y_l[0];
        z = (z_h[0] << 8) | z_l[0];

        x = x;
        y = y;
        z = z;


        angle_x=atan2(y,z)*180;
        angle_x=angle_x/3.14;

        angle_y=atan2(x,z)*180;
        angle_y=angle_y/3.14;

        angle_z=atan2(y,x)*180;
        angle_z=angle_z/3.14;

        angle_x1=angle_x*0.9+0.1*(angle_x1-xAxis*0.005);
        angle_y1=angle_y*0.9+0.1*(angle_y1-yAxis*0.005);
        angle_z1=angle_z*0.9+0.1*(angle_z1-zAxis*0.005);

        printf("Angle_x %f\t\n", angle_x1);
        printf("Angle_y %f\t\n", angle_y1);
        printf("Angle_z %f\t\n", angle_z1);//不具有参考意义，较大误差

        x_int = (int)(angle_x1*10+900);
        y_int = (int)(angle_y1*10+900);
        printf("x_int %d\t\n", x_int);
        printf("y_int %d\t\n", y_int);

        x_int = x_int/3;
        y_int = y_int/3;

        c1 <: x_int;
        c2 <: y_int;

        DelayMs(10);
        DelayMs(10);
    }
}
