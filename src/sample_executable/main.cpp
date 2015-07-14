#include <sample_module/foo.h>
#include "bar.h"
#include "subfolder/baz.h"
#include "subfolder/subsubfolder/bazz.h"

int main()
{
    Foo* foo = new Foo();
    Bar* bar = new Bar();
    Baz* baz = new Baz();
    Bazz* bazz = new Bazz();

    foo->inc();
    foo->dec();

    bar->setValue(1);

    int ii = 0;
    ii++;
}
