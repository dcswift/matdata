set xlabel 'mass density (g/cm^3)'
set ylabel 'pressure (GPa)'
set logscale y
set key bottom right
plot [3:7][10:1e3] \
   'hugoniot/marsh.txt' ind 0 u 10:11 title 'Marsh', \
   'hugoniot/vanthiel.dat' ind 0 u ($1/$5):($4/10) title 'van Thiel', \
   'models/leos2130/hugoniot.dat' u 1:6 title 'LEOS 2130' w l
