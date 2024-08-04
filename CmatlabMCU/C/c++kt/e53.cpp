/*#include <iostream>
#include <stdlib.h>
using namespace std;
int main()
{
	int year, month, day;
	bool b = false;
	cin >> year >> month >> day;
	if (year % 400 == 0)
		b = true;
	else if (year % 100 != 0 && year % 4 == 0)
		b = true;
	if (b)
		cout << "是闰年" << endl;
	else
		cout << " 不是闰年" << endl;
	switch (month)
	{
	case1:case3:case5:case7:case8:case10:case12:
		cout << "这个月有31天" << endl;
		break;
	case4:case6:case9:case11:
		cout << "这个月有30天" << endl;
		break;
	case2:
		cout << "这个月有" << (b ? 29 : 28) << endl;
		break;
	};
	system("pause");
	return 0;
}*/