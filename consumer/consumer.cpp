#include "consumer.h"
#include "libdep.h"
int get_value_from_consumer() { return get_dep_value() + 1; }