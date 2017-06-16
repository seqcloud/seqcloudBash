# Note the use of double quotes in the Rscript command. Single quote usage,
# which is common in online examples, will not escape the bash variables
# properly.
ram_gb="$1"
ram_mb="$(($ram_gb * 1024))"
file_name="$2"
echo "Rendering $file_name with $ram_gb GB RAM..."
# [fix] Add check for Orchestra
bsub -W 12:00 -q priority -J "$file_name" -n 1 -R rusage[mem="$ram_mb"] Rscript --default-packages="$R_DEFAULT_PACKAGES" -e "rmarkdown::render('$file_name')"
