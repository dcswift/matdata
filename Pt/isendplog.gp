set terminal postscript eps color enhanced solid 20
#set terminal aqua 0 font "Helvetica,25" enhanced solid
#set terminal wxt font "Helvetica,10" enhanced

set xlabel 'mass density (g/cm^3)'
set ylabel 'normal stress (TPa)'

set key top left
set style data lines

set style line 1 lt rgbcolor "#aa0000" lw 2
set style line 11 lt rgbcolor "#aa0000" lw 1
set style line 12 lt rgbcolor "#550000" lw 2
set style line 2 lt rgbcolor "#00aa00" lw 2
set style line 21 lt rgbcolor "#00aa00" lw 1
set style line 3 lt rgbcolor "#0000aa" lw 2
set style line 31 lt rgbcolor "#0000aa" lw 1
set style line 4 lt rgbcolor "#00aaaa" lw 2
set style line 41 lt rgbcolor "#00aaaa" lw 1
set style line 5 lt rgbcolor "#aa00aa" lw 2
set style line 51 lt rgbcolor "#aa00aa" lw 1
set style line 6 lt rgbcolor "#aaaa00" lw 2
set style line 61 lt rgbcolor "#aaaa00" lw 1
set style line 7 lt rgbcolor "#555555" lw 2

set logscale y
pl [20:55][0.01:2.500] \
   'models/leos780/isentrope.dat' u 1:($15/1e3) title 'LEOS 780' w l ls 2, \
   'models/sesame3730/isentrope.dat' u 1:($15/1e3) title 'SESAME 3730' w l ls 3, \
   'models/sesame3732/isentrope.dat' u 1:($11/1e3) title 'SESAME 3732' w l ls 4, \
   'models/inferno81j/isentrope.dat' u 1:($15/1e3) title 'AJ' w l ls 5, \
   'ramp/fratanduono2021.dat' u 1:($2/1e3):($3/1e3) title 'Fratanduono' w yerrorbars ls 4, \
   'ramp/davis.dat' u 1:($2/1e3) title 'Davis' w points ls 3, \
   'ramp/coppari.dat' u 1:($3/1e3):2:(($4+$5)/2e3) title 'Coppari' w xyerrorbars ls 2, \
   'diffraction/nif1.dat' ind 1 u 2:($4/1e3):3:($5/1e3) title 'NIF VISAR peak' w xyerrorbars ls 1
#  'nifxrd1.dat' ind 0 u 2:($4/1e3):3:($5/1e3) title 'NIF postshot' w xyerrorbars ls 12, \
#  'Ptcg.isen' u 1:(-$5/1e3) title 'Steinberg' w l ls 3, \
#  'Pt3730_sg.isen' u 1:(-$5/1e3) title 'Steinberg-Guinan' w l ls 21, \
#  '../inferno/81j/tbdap.isen' u 1:($15/1e3) title 'AJ B' w l ls 5, \
#  '../inferno/81j/ttdap.isen' u 1:($15/1e3) title 'AJ T' w l ls 6, \
#  '../inferno/81j/tadap_sg.isen' u 1:(-$5/1e3) title 'AJ A+SG' w l ls 41, \
#  '../inferno/81j/tbdap_sg.isen' u 1:(-$5/1e3) title 'AJ B+SG' w l ls 51, \
#  (608.496-66.2122*x+1.77718*x**2)/1e3 title 'SESAME 3739' ls 4, \
#  (595.487-65.7165*x+1.77513*x**2)/1e3 notitle 'LEOS 780' ls 5 dt 2, \
#  '../inferno/81j/Pt_isen.dat' u 3:($11/1e3) title 'AJ+heating' w l ls 41, \
