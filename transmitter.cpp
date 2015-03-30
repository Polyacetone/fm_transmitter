#include "transmitter.h"
#include <sys/mman.h>
#include <fcntl.h>
#include <exception>
#include <iostream>


Transmitter::Transmitter()
{
    int memFd;
    if ((memFd = open("/dev/mem", O_RDWR | O_SYNC)) < 0) {
        std::cout << "Sudo privileges are required!" << std::endl;
        throw std::exception();
    }

    void *gpioMap = mmap(NULL, 0xB1, PROT_READ | PROT_WRITE, MAP_SHARED, memFd, 0x20200000);
    if (gpioMap == MAP_FAILED) {
        close(memFd);
        std::cout << "MMAP error - " << (int)gpioMap << std::endl;
        throw std::exception();
    }

    gpio = (volatile unsigned*)gpioMap;

    void *clockMap = mmap(NULL, 0x12, PROT_READ | PROT_WRITE, MAP_SHARED, memFd, 0x20101070);
    close(memFd);
    if (clockMap == MAP_FAILED) {
        std::cout << "MMAP error - " << (int)clockMap << std::endl;
        throw std::exception();
    }

    clock = (volatile unsigned*)clockMap;
}

Transmitter::~Transmitter()
{
    //dtor
}