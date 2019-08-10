#!/usr/bin/env bash

export LC_ALL=C
TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
BUILDDIR=${BUILDDIR:-$TOPDIR}

BINDIR=${BINDIR:-$BUILDDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

DIAZD=${DIAZD:-$BINDIR/diazd}
DIAZCLI=${DIAZCLI:-$BINDIR/diaz-cli}
DIAZTX=${DIAZTX:-$BINDIR/diaz-tx}
WALLET_TOOL=${WALLET_TOOL:-$BINDIR/diaz-wallet}
DIAZQT=${DIAZQT:-$BINDIR/qt/bitcoin-qt}

[ ! -x $DIAZD ] && echo "$DIAZD not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
read -r -a DIAZVER <<< "$($DIAZCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }')"

# Create a footer file with copyright content.
# This gets autodetected fine for diazd if --version-string is not set,
# but has different outcomes for bitcoin-qt and diaz-cli.
echo "[COPYRIGHT]" > footer.h2m
$DIAZD --version | sed -n '1!p' >> footer.h2m

for cmd in $DIAZD $DIAZCLI $DIAZTX $WALLET_TOOL $DIAZQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${DIAZVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${DIAZVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
