#pragma once

#include <project_config.h>

#if D_DYNAMIC_LINKING
#define D_EXPORT __declspec(dllexport)
#else
#define D_EXPORT
#endif
