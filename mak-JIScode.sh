#!/bin/sh

CODE=./code.txt
TDTOP=./tdtop.txt
PERL=./bdf2bit.pl
cat <<EOT > $PERL
#!/usr/bin/perl -p
# vi:set ts=8 sts=4 sw=4 tw=0:

if (/^[0-9a-fA-F]+\$/)
{
    chomp;
    \$_ = unpack("B*", pack("H*", \$_)) . "\n";
    y/01/.@/;
}

EOT
chmod a+x $PERL

BDF=k12x10bdf/k12x10.bdf
BIT=k12x10.bit

$PERL $BDF > $BIT
RC=$?
if [ $RC -ne 0 ]; then
  echo $PERL fail.
  exit $RC
fi

rm -f jisx0208.html
wget http://www.asahi-net.or.jp/~ax2s-kmtn/ref/jisx0208.html
if [ $RC -ne 0 ]; then
  echo $PERL fail.
  exit $RC
fi

# td$B%?%0$N$_$K$9$k(B
LF=$(printf '\\\012_');LF=${LF%_}
sed -n '/<table class="basic"/,/<ul class="t_note">/p' jisx0208.html |
grep -v '<ul class="t_note">'                                        |
sed "s/<td/${LF:?}<td/g"                                             |
awk '{if (0 < NF) {print;}}'                                         > ${TDTOP:?}

AWK=./tdonly.awk
cat <<EOT > ${AWK:?}
BEGIN{
  # kind
  # 0   <th>$B6h(B</th>
  # 1   <th>$BE@(B</th>
  # 2   <th>JIS</th>
  # 3   <th>SJIS</th>
  # 4   <th>EUC</th>
  kind = 0;
  count = 0;
}
{
  kind++;
  if (\$0 ~ /th class="v" rowspan="6"/)  {    # JIS X 0208$B%3!<%II=$N6hE@$N6h(B
    count = 0;
    kind = 0;
    next;
  } else {
    if (kind == 2) {                          # JIS
      jis =  \$0;
      sub(/<th class="v">/, "", jis);
      sub(/<\/th>/, "", jis);
      next;
    }
    if (\$0 ~ /<th/) {                        # th$B%?%0$O%9%-%C%W(B
      next;
    }
    if (\$0 ~ /<tr/ || \$0 ~ /<\/tr/) {       # tr$B%?%0$O%9%-%C%W(B
      next;
    }
    if (\$0 ~ /<table/ || \$0 ~ /<\/table/) { # table$B%?%0$O%9%-%C%W(B
      next;
    }
    if (\$0 ~ /<br/) {                        # br$B%?%0$O%9%-%C%W(B
      next;
    }
    sub(/<td[^>]*>/, "");                     # td$B%?%0$N$_=hM}(B
    sub(/<\/td>/, "");

    system(sprintf("./dec2hex.sh %d", count));
    getline val < "/tmp/dec2hex.result";
    close("/tmp/dec2hex.result");

    system(sprintf("./hexcal.sh \"%s + %s\"", jis, val));
    getline val < "/tmp/hexcal.result";
    close("/tmp/hexcal.result");

    printf("%s\t%s\n", \$0, val);
    count++;
  }
}
EOT

awk -f ${AWK:?} ${TDTOP:?} > ${CODE:?}

