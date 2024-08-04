#pragma once
#include <iostream>
int f1(int n)
{
	int a = 1;
	for (int i = 1; i <= n; i++)
	{
		a = a * i;
	}
	return a;
}