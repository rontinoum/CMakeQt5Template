#include <sample_module/foo.h>
#include "bar.h"

int main()
{
    Foo* foo = new Foo();
    Bar* bar = new Bar();

    foo->inc();
    foo->dec();

    bar->setValue(1);

    int ii = 0;
    ii++;
}