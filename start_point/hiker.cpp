#include "hiker.hpp"
#include "disk_logger.hpp"

Hiker::Hiker()
    : logger(DiskLogger::getInstance())
{
}


Hiker::Hiker(Logger & logger)
    : logger(logger)
{
}

int Hiker::answer()
{
    logger.log("Hiker::answer()");
    return 6 * 9;
}
