
############################################################################
# AUTHOR: DANIEL GASPAR GONÇALVES - 16/07/2019 - V1.0                      #
# convert pdf file into images (png, jpg ...)                              #
# USAGE: ./converter_pdf.sh "path containing pdf files" "output extension" #
############################################################################

# Possibly error and how to solve
# # """convert:not authorized ... """ ERROR
# sudo vim /etc/ImageMagick-6/policy.xml
# change '''policy domain="coder" rights="none" pattern="PDF"''' to '''policy domain="coder" rights="read|write" pattern="PDF"'''

path=$1
output_ext=$2

if [ -z "$output_ext" ]
then
	output_ext="png";
fi

if [ -n $path ]
then
	for i in $(ls $path/*pdf); do
		npages=$(qpdf --show-npages $i)


		if [ $npages -eq 1 ]
		then
			png_name=$(printf $i | awk 'match($1,/(.*)\.pdf/, a){print substr(a[1], RSTART, RLENGTH-1)}')
			convert -verbose -density 150 -quality 100 -flatten -sharpen 0x1.0 -trim $i $png_name"."$output_ext 2>/dev/null
		else			
			for j in $(seq 0 $(expr $npages - 1)); do
				png_name=$(printf $i | awk -v npages=$j 'match($1,/(.*)\.pdf/, a){print substr(a[1], RSTART, RLENGTH-1)"_"npages}')
				convert -verbose -density 150 -quality 100 -flatten -sharpen 0x1.0 -trim $i[$j] $png_name"."$output_ext 2>/dev/null
				printf $i[$j]" > "$png_name"."$output_ext"\n"
			done
		fi
	done
else
	printf "Error: Input path missing."
fi
