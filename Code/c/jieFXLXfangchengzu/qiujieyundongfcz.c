#include <stdio.h>
#include <math.h>
#define RAD 57.3
double ACX[5][6],ACY[6][6],AMZAF[5][6],AMZWZ[5][2],
AXG[11][2],AJZ[3][2],AP[2],AMC[2],AGC[2],ANDM[2],
ANDAF[2],Y[8],B[3],L,S,SONIC,RHO,
double MA,ABC ALPHA,CX,CY,MZAF,MZWZ,XG,JZ,ALPHA;
FILE *fi,*fo;
//主函数
main()
{
	void rk();
	void result();
	int i,j;
	double h;
	fi=fopen("input.dat","+");
	for(i=0;i<5;i++)
	{
		for(j=0;j<6;j++)
			fscanf(fi,"%lf",& ACX[i][j]);
	}	
	for(i=0;i<5;i++)
	{
		for(j=0;j<6;j++)
			fscanf(fi,"%lf",& ACY[i][j]);
	}
	for(i=0;i<5;i++)
	{
		for(j=0,j<6;j++)
			fscanf(fi,"%1f",& AMZAFC[i][j]);
	}
	for(i=0;i<5;i++)
	{
		for(j=0;j<2;j++)
			fscanf(fi,"%lf",& AMZWZ[i][j]);
	}
	for(i=0;i<11;i++)
	{
		for(j=0;j<2;j++)
			fscanf(fi,"%lf",& AXG[i][j]);
	}
	for(i=0;i<3;i++)
	{
		for(j=0;j<2;j++)
			fscanf(fi,"%lf",& AJZ[i][j]);
	}
	for(j=0;j<2:j++)
		fscanf(fi,"%1f",&. AJZC[i]C[j]);
	for(i=0;i<2;i++)
		fscanf(fi,"%1f",&. APC[i]);
	for(i =0;i<2;i++)
		fscanf(fi,"%1f",&AMCC[i]);
	for(i =0,i<2;i++)
		fscanf(fi,"%1f",&. AGC[i]);
	for(i =0;i<2;i++)
		fscanf(fi,"%1f",& ANDM[i]);
	for(i=0;i<2;i++)
		fscanf(fi,"%1f",& ANDAF[i]);
	for(i =0;i<8;i++)
		fscanf(fi,"%1f",&.Y[i]);
	for(i=0;i<3;i++)
		fscanf (fi,"%1f",&. B[i]);
	fscanf(fi,"%lf%lf%lf%lf%lf%lf",&L,&S,&SONIC,&RHO,&h);
	close (fi);

	fo=fopen("output. dat","w");
	fprintf(fo,"%s","TIME  ALPHA  V  X  Y  ");
	fprintf(fo,"%s","MASS  THETA  GTHETA WZ");
	fprintf(fo,"\n");
	fprintf (fo,"%s"," s   rad   m/s   m   m  ");
	fprintf(fo,"%s"," kg   rad   rad   rad/s");
	fprintf(fo,"n");
	rk(8,h);

	do{
		result();
		rk(8,h);
	}
	while(Y[6>=0]);
}
