#ifndef _FOO_H_
#define _FOO_H_

class __declspec(dllexport) Foo
{
public:
    Foo();
    ~Foo();
    void inc();
    void dec();
    
private:
    int _value;
};

#endif //_FOO_H_