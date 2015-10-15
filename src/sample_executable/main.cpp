#include "sample_module/foo.h"

#include "sample_executable/bar.h"
#include "sample_executable/subfolder/baz.h"
#include "sample_executable/subfolder/subsubfolder/bazz.h"

int main()
{
    sample_module::Foo* foo = new sample_module::Foo();
    sample_executable::Bar* bar = new sample_executable::Bar();
    Baz* baz = new Baz();
    Bazz* bazz = new Bazz();

    foo->inc();
    foo->dec();

    bar->setValue(1);

    int ii = 0;
    ii++;
}
