git ls-remote bb:swsc/lookup
git ls-remote gh:fdac20/news
git ls-remote gl:inkscape/inkscape
git ls-remote gl_gnome:gnome/gtk
git ls-remote dr:project/drupal.git
git ls-remote deb:Debian/qr-tools

# Date time
DT=202109
DTdash=2021-09-10

# Past date time
PDT=202102
PDTdash=2021-02-10

# Past unix timestamp
PT=$(date -d"$PDTdash" +%s)

# Current unix timestamp
T=$(date -d"$DTdash" +%s)

# Get number of tokens and equally divide time by tokens
nTokens=$(cat tokens | wc -l)
inc=$(( ($T - $PT) / $nTokens ))

# Assign time intervals to each token to cover all times between last collection (PT) and now (T)
for i in $(seq $nTokens)
do 
	endInterval=$(date -d "@"$(( $PT + ($i-1) * $inc )) +"%Y-%m-%d")
	startInterval=$(date -d "@"$(($PT + ($i) * $inc)) +"%Y-%m-%d")
	echo $(awk -v i=$i 'NR==i' tokens) $endInterval $startInterval
done > tokens_date

for i in {1..9} 
do 
	# TODO: move writing commands to python script
	# cat tokens_date | awk -v i=$i 'NR==i' | python3 ghUpdatedrepos.py gh$DT repos & done
	(r=$(awk -v i=$i 'NR==i' tokens_date) echo $r | python3 ghUpdatedRepos.py gh$DT repos  &> ghReposList$(echo $r | cut -d ' ' -f2).updt) & 
done
