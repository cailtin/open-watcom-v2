/****************************************************************************
*
*                            Open Watcom Project
*
*    Portions Copyright (c) 1983-2002 Sybase, Inc. All Rights Reserved.
*
*  ========================================================================
*
*    This file contains Original Code and/or Modifications of Original
*    Code as defined in and that are subject to the Sybase Open Watcom
*    Public License version 1.0 (the 'License'). You may not use this file
*    except in compliance with the License. BY USING THIS FILE YOU AGREE TO
*    ALL TERMS AND CONDITIONS OF THE LICENSE. A copy of the License is
*    provided with the Original Code and Modifications, and is also
*    available at www.sybase.com/developer/opensource.
*
*    The Original Code and all software distributed under the License are
*    distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
*    EXPRESS OR IMPLIED, AND SYBASE AND ALL CONTRIBUTORS HEREBY DISCLAIM
*    ALL SUCH WARRANTIES, INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF
*    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR
*    NON-INFRINGEMENT. Please see the License for the specific language
*    governing rights and limitations under the License.
*
*  ========================================================================
*
* Description:  WHEN YOU FIGURE OUT WHAT THIS FILE DOES, PLEASE
*               DESCRIBE IT HERE!
*
****************************************************************************/


#include "cpplib.h"
#include "rtexcept.h"
#include "rtarctor.h"


extern "C"
_WPRTLINK
void * CPPLIB( ctor_array )(    // CALL CONSTRUCTORS FOR ARRAY ELEMENTS
    void *array,                // - array
    unsigned count,             // - number of elements
    RT_TYPE_SIG sig )           // - signature of array
{
    unsigned size;              // - size of one element
    pFUNctor ctor;              // - constructor for an element
                                // - array-ctor control
    _RTARCTOR ar_ctor( 0, sig, array );

    ctor = sig->clss.ctor;
    size = sig->clss.size;
    while( ar_ctor._count < count ) {
        (*ctor)( array );
        array = (void *)( ((char*)array) + size );
        ++ ar_ctor;
    }
    ar_ctor.complete();
    return ar_ctor._array;
}
