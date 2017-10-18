http://z.apps.atjp.jp/k12x10/

  ./k12x10bdf
  ├── ./k12x10bdf/k12x10.bdf
  ├── ./k12x10bdf/k6x10.bdf
  └── ./k12x10bdf/readme.euc

  mak-JIScode.sh :k12x10.bit、code.txt作成
  dec2hex.sh     :10->16変換
  hexcal.sh      :16進計算
  deka.awk       :banner作成

0 171018-192113 indou@vostro:zoroyoshi2banner:$ echo "改良版" |awk -f ./deka.awk 
@@@@ @              @           @ @  @@@@@@     
   @ @@@@@@      @@@@@@@@       @ @  @          
   @ @  @        @      @       @ @  @          
@@@@ @  @        @@@@@@@@       @@@@ @@@@@@     
@   @ @ @        @      @       @    @@   @     
@      @         @@@@@@@@       @@@@ @ @ @      
@  @   @@        @  @  @        @  @ @  @       
 @@@  @  @       @  @@@         @  @@  @ @      
    @@    @     @@@@   @@@@     @  @ @@   @     
                                                
0 171018-192134 indou@vostro:zoroyoshi2banner:$ 

