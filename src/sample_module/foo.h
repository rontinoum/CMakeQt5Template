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