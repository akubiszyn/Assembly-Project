#include <stdio.h>
#include <fstream>
#include <iostream>

extern "C" int turtle(unsigned char *dest_bitmap, unsigned char *commands, unsigned int commands_size);
using std::fstream;	using std::ios;
using std::cout;	using std::endl;

int main(void)
{
	fstream file_bmp;
	file_bmp.open("output.bmp", ios::in | ios::binary);
	if (file_bmp.is_open())
	{
	  unsigned char bytes_bmp[90123];
	  int counter_bmp = 0;
	  while (not file_bmp.eof())
	  {
		bytes_bmp[counter_bmp] = file_bmp.get();
		counter_bmp +=1;
	  }
    file_bmp.close();
    fstream file_bin;
	file_bin.open("input.bin", ios::in | ios::binary);
	if (file_bin.is_open())
	{
	  unsigned char bytes_bin[61];
	  int counter_bin = 0;
	  while (not file_bin.eof())
	  {
		bytes_bin[counter_bin] = file_bin.get();
		counter_bin +=1;
	  }
    counter_bin -=1;
    cout << counter_bin << endl;
    cout << bytes_bin << endl;
	//   printf("Returned value\t\t> %i\n", returned_value);
	//   file_bin.close(); pozniej sobie zamkniemy
      int result = turtle(bytes_bmp, bytes_bin, counter_bin);
	  FILE* output = fopen("output.bmp", "wb");
    fwrite(bytes_bmp, 1, 90122, output);
    fclose(output);
    std::cout << result  << std::endl;
      file_bin.close();
	  return 0;
	}
	else
	{
		cout << "Otwieranie pliku bin sie nie powiodlo" << endl;
		return 1;
	}
	//   int returned_value = turtle(bytes_bmp);
	//   printf("Returned value\t\t> %i\n", returned_value);
	//   file_bmp.close();   //bedzie trzeba pozniej zamknac
	  return 0;
	}
	else
	{
		cout << "Otwieranie pliku bmp sie nie powiodlo" << endl;
		return 1;
	}
}
