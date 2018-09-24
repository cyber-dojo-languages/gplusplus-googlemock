#ifndef HIKER_INCLUDED
#define HIKER_INCLUDED

class Logger;

class Hiker
{
public:
    Hiker();
    explicit Hiker(Logger &);
    int answer();
private:
    Logger & logger;
};

#endif
