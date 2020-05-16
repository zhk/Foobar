
#pragma once

#include <foo/foo-config.h>


#if defined(_WIN32)
#	if defined(FOO_STATIC)
#			define FOO_API
#   else
#       if defined( foo_shared_EXPORTS )
#		    define FOO_API __declspec(dllexport)
#	    else
#		    define FOO_API __declspec(dllimport)
#	    endif
#	endif
#endif

void FOO_API foo(void);

