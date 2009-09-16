#!/bin/bash -x
# $Id$

LIST="
trunk/atg/adpmake/adpmaker.pl
trunk/atg/adpmake/utils/adp.sh
trunk/atg/adpmake/utils/l.sh
trunk/atg/adpmake/utils/lnmdbfile.sh
trunk/atg/pex/pex.pl
trunk/atg/pex/pex.def.pl.sql
trunk/atg/pex/pex.def.scp.sh
trunk/atg/pex/pex.ins.sh
trunk/atg/pex/pex.transfer.sh
trunk/atg/pex/stab.sh
"

ROOT=/home/marcus/work/
 TAG=adpmake-0.30
DTAG=$ROOT/tag/$TAG

if [ ! -d $DTAG ]
then
    mkdir -p $DTAG
    svn add  $DTAG
fi

for f in $LIST
do
    echo $f
    svn cp $ROOT/$f $DTAG
done

echo svn commit -m "Tag: $TAG" $ROOT/$DTAG

