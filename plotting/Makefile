firstDataCsv := $(shell ls *_data.csv | head -n 1)
allDataCsv := $(shell ls *_data.csv)
allNflocksCsv := $(subst data.csv,nflocks.csv,$(allDataCsv))
allFlocksizes := $(subst data.csv,flocksizes.png,$(allDataCsv))
allNflocks := $(subst data.csv,nflocks.png,$(allDataCsv))
allSpeed := $(subst data.csv,speed.png,$(allDataCsv))

all: all-flocksizes all-nflocks all-speed nflocks_stats.png nflocks_combined.png nflocks_direkt.png
all-flocksizes: $(allFlocksizes)
all-nflocks: $(allNflocks)
all-speed: $(allSpeed)
all-csv-nflocks: $(allNflocksCsv)

clean-all:
	rm -f *.png $(allNflocksCsv) frames.csv

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
		plot	\"$<\" using (column(1)):(column(18)) with lines title '# subflocks', \
			\"$<\" using (column(1)):(column(19)) with lines title '# predators'" \
	 | gnuplot

%_speed.png: %_data.csv Makefile
	echo " \
		set datafile separator ',' \n\
		 \n\
		set term pngcairo size 1024,768 \n\
		set grid \n\
		set title \"Run $<\" noenhanced \n\
		set xlabel \"Time [framenumer]\" \n\
		set ylabel \"Speed [m/s]\" \n\
		set y2label \"Mode/count\" \n\
		set yrange [0:60] \n\
		set y2range [0:4] \n\
		set y2tics 1.0 \n\
		set output \"$@\" \n\
		plot	\"$<\" using (column(1)):(column(19)) with lines title '# predators' axes x1y2, \
			\"$<\" using (column(1)):(column(20)) with lines title 'predator mode (1=ATTACK, 2=HOVER, 3=FOLLOW)' axes x1y2, \
			\"$<\" using (column(1)):(column(21)) with lines title 'predator speed', \
			\"$<\" using (column(1)):(column(27)) with lines title 'avg. bird speed'" \
	 | gnuplot

%_nflocks.csv: %_data.csv Makefile
	cut $< -f 18 -d "," > $@

frames.csv: $(firstDataCsv) Makefile
	cut $< -f 1 -d "," > $@

combined_logs.csv: frames.csv $(allNflocksCsv)
	paste -d ',' $+ | gawk -F ',' '{\
		arr[1]=$$2; \
		arr[2]=$$3; \
		arr[3]=$$4; \
		arr[4]=$$5; \
		arr[5]=$$6; \
		arr[6]=$$7; \
		arr[7]=$$8; \
		arr[8]=$$9; \
		arr[9]=$$10; \
		arr[10]=$$11; \
		sum=arr[1]+arr[2]+arr[3]+arr[4]+arr[5]+arr[6]+arr[7]+arr[8]+arr[9]+arr[10]; \
		asort(arr, sarr); \
		print $$1","arr[1]","arr[2]","arr[3]","arr[4]","arr[5]","arr[6]","arr[7]","arr[8]","arr[9]","arr[10]","sum","sarr[1]","(sarr[5]+sarr[6])/2","sarr[10]","sarr[3]","sarr[8]; \
	}' > $@
	paste -d '' $+ 
	#cat $@

nflocks_stats.png: combined_logs.csv Makefile
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
		plot	\"$<\" using (column(1)):(column(13)) with lines linecolor rgb '#33DDDDDD' title 'min' noenhanced, \
			\"$<\" using (column(1)):(column(15)) with lines linecolor rgb '#33DDDDDD' title 'max' noenhanced, \
			\"$<\" using (column(1)):(column(13)):(column(15)) with filledcurves linecolor rgb '#AADDDDDD' notitle noenhanced, \
			\"$<\" using (column(1)):(column(16)) with lines linecolor rgb '#33AAAAAA' title '20percentile' noenhanced, \
			\"$<\" using (column(1)):(column(17)) with lines linecolor rgb '#33AAAAAA' title '80percentile' noenhanced, \
			\"$<\" using (column(1)):(column(16)):(column(17)) with filledcurves linecolor rgb '#AAAAAAAA' notitle noenhanced, \
			\"$<\" using (column(1)):(column(14)) with lines linecolor rgb '#0000BB' title 'med' noenhanced" \
	 | gnuplot

nflocks_combined.png: combined_logs.csv Makefile
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
		plot	\"$<\" using (column(1)):(column(2)) with lines title 'run 1' noenhanced, \
			\"$<\" using (column(1)):(column(3)) with lines title 'run 2' noenhanced, \
			\"$<\" using (column(1)):(column(4)) with lines title 'run 3' noenhanced, \
			\"$<\" using (column(1)):(column(5)) with lines title 'run 4' noenhanced, \
			\"$<\" using (column(1)):(column(6)) with lines title 'run 5' noenhanced, \
			\"$<\" using (column(1)):(column(7)) with lines title 'run 6' noenhanced, \
			\"$<\" using (column(1)):(column(8)) with lines title 'run 7' noenhanced, \
			\"$<\" using (column(1)):(column(9)) with lines title 'run 8' noenhanced, \
			\"$<\" using (column(1)):(column(10)) with lines title 'run 9' noenhanced, \
			\"$<\" using (column(1)):(column(11)) with lines title 'run 10' noenhanced" \
	 | gnuplot

nflocks_direkt.png: $(allDataCsv) Makefile
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
			\"$(word 9,$+)\" using (column(1)):(column(18)) with lines title '$(word 9,$+)' noenhanced, \
			\"$(word 10,$+)\" using (column(1)):(column(18)) with lines title '$(word 10,$+)' noenhanced" \
	 | gnuplot



