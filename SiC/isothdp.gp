set xlabel 'mass density (g/cm^3)'
set ylabel 'pressure (GPa)'
set logscale y
set key bottom right
plot [3:12][10:2e3] \
   'models/leos2130/isotherm0k.dat' u 1:3 title 'LEOS 2130' w lines, \
   'estruc/castep/NaCl.dat' u 1:3 title 'NaCl' w lines, \
   'estruc/castep/CsCl.dat' u 1:3 title 'CsCl' w lines, \
   'estruc/castep/cZnS.dat' u 1:3 title 'cZnS' w lines, \
   'estruc/vasp/NaCl-wilson.dat' u 2:1 title 'NaCl VASP' w lines, \
   'estruc/vasp/Cmcm-wilson.dat' u 2:1 title 'Cmcm VASP' w lines, \
   'dac/Kidokoro2017add.dat' u 5:1:6:2 title 'DAC: Kidokoro 2017' w xyerrorbars, \
   'ramp/Kim2022_supptab2.dat' u 6:2:7:3 title 'ramp: Kim 2022 pl' w xyerrorbars
