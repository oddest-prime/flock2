allDataCsv := $(shell ls *_data.csv)
allFlocksizes := $(subst data.csv,flocksizes.png,$(allDataCsv))
allNflocks := $(subst data.csv,nflocks.png,$(allDataCsv))

clean-all:
	rm *.png

all: all-flocksizes all-nflocks nflocks.png
all-flocksizes: $(allFlocksizes)
all-nflocks: $(allNflocks)

%_flocksizes.png: %_data.csv Makefile
	echo " \
		set datafile separator ',' \n\
		 \n\
		set term pngcairo size 1024,768 \n\
		set grid \n\
		set title \"Run $<\" noenhanced \n\
		set xlabel \"Time [framenumer]\" \n\
		set ylabel \"# of agents\" \n\
		set output \"$@\" \n\
		plot	\"$<\" using (column(1)):(column(2)) with lines title 'subflock 0 size', \
			\"$<\" using (column(1)):(column(3)) with lines title 'subflock 1 size', \
			\"$<\" using (column(1)):(column(4)) with lines title 'subflock 2 size', \
			\"$<\" using (column(1)):(column(5)) with lines title 'subflock 3 size', \
			\"$<\" using (column(1)):(column(6)) with lines title 'subflock 4 size', \
			\"$<\" using (column(1)):(column(7)) with lines title 'subflock 5 size', \
			\"$<\" using (column(1)):(column(8)) with lines title 'subflock 6 size', \
			\"$<\" using (column(1)):(column(9)) with lines title 'subflock 7 size', \
			\"$<\" using (column(1)):(column(10)) with lines title 'subflock 8 size', \
			\"$<\" using (column(1)):(column(11)) with lines title 'subflock 9 size', \
			\"$<\" using (column(1)):(column(12)) with lines title 'subflock 10 size', \
			\"$<\" using (column(1)):(column(13)) with lines title 'subflock 11 size', \
			\"$<\" using (column(1)):(column(14)) with lines title 'subflock 12 size', \
			\"$<\" using (column(1)):(column(15)) with lines title 'subflock 13 size', \
			\"$<\" using (column(1)):(column(16)) with lines title 'subflock 14 size', \
			\"$<\" using (column(1)):(column(17)) with lines title 'subflock 15 size'" \
	 | gnuplot

%_nflocks.png: %_data.csv Makefile
	echo " \
		set datafile separator ',' \n\
		 \n\
		set term pngcairo size 1024,768 \n\
		set grid \n\
		set title \"Run $<\" noenhanced \n\
		set xlabel \"Time [framenumer]\" \n\
		set ylabel \"Number of subflocks\" \n\
		set yrange [0:15] \n\
		set output \"$@\" \n\
		plot	\"$<\" using (column(1)):(column(18)) with lines title '# subflocks'" \
	 | gnuplot

nflocks.png: $(allDataCsv) Makefile
	echo " \
		set datafile separator ',' \n\
		 \n\
		set term pngcairo size 1024,768 \n\
		set grid \n\
		set title \"multiple runs compared\" noenhanced \n\
		set xlabel \"Time [framenumer]\" \n\
		set ylabel \"Number of subflocks\" \n\
		set yrange [0:15] \n\
		set output \"$@\" \n\
		plot	\"$(word 1,$+)\" using (column(1)):(column(18)) with lines title '$(word 1,$+)' noenhanced, \
			\"$(word 2,$+)\" using (column(1)):(column(18)) with lines title '$(word 2,$+)' noenhanced, \
			\"$(word 3,$+)\" using (column(1)):(column(18)) with lines title '$(word 3,$+)' noenhanced, \
			\"$(word 4,$+)\" using (column(1)):(column(18)) with lines title '$(word 4,$+)' noenhanced, \
			\"$(word 5,$+)\" using (column(1)):(column(18)) with lines title '$(word 5,$+)' noenhanced, \
			\"$(word 6,$+)\" using (column(1)):(column(18)) with lines title '$(word 6,$+)' noenhanced, \
			\"$(word 7,$+)\" using (column(1)):(column(18)) with lines title '$(word 7,$+)' noenhanced, \
			\"$(word 8,$+)\" using (column(1)):(column(18)) with lines title '$(word 8,$+)' noenhanced, \
			\"$(word 9,$+)\" using (column(1)):(column(18)) with lines title '$(word 9,$+)' noenhanced" \
	 | gnuplot



