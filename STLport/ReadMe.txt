Configuring STLport
===================

- Enable the following in stlport\stl\config\host.h

#ifdef _DEBUG
#define _STLP_LEAKS_PEDANTIC 1
#endif

#ifdef _DEBUG
#define _STLP_USE_MALLOC 1
#endif
