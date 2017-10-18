#
# 
#
BEGIN{
  codefile = "./code.txt";
  bitfile = "./k12x10.bit";
  FS = "\t";
  while ((getline < codefile) > 0) {
    buf[$1] = $2;
  }
}
{
  maxlen =length($0);
  for (i = 1; i <= maxlen; i++) {
    banner = sprintf("banner%02d", i);
    system(sprintf("rm -f %s", banner));
    str = substr($0, i, 1);
    code = buf[str];
    sub(/-/, "", code);
    str = sprintf("STARTCHAR %s", tolower(code)); 
    printf("d:%s:%s:%s\n", str, code, banner) > "./debug.txt";
    hit = 0;
    while ((getline line < bitfile) > 0) {
      if (hit == 1 && line == "ENDCHAR") {
        hit = 0;
        out = 0;
      }
      if (out == 1) {
        gsub(/\./, " ", line);
        printf("%s\n", line) >> banner;
      }
      if (line == str) {
        hit = 1;
      }
      if (hit == 1 && line == "BITMAP") {
        out = 1;
      }
    }
    close(bitfile);
    fflush();
  }
}
END {
  for (i = 1; i <= maxlen; i++) {
    banner = sprintf("banner%02d", i);
    count = 0;
    while ((getline line < banner) > 0) {
      count++;
      outbuf[count] = sprintf("%s%s", outbuf[count], line);
      maxline = count;
    }
    close(banner);
  }
  for (i = 1; i <= maxline; i++) {
    printf("%s\n", outbuf[i]);
  }
}
