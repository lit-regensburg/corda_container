for f in $1/*
do
  file_name="${f##*/}"
  file_name="${file_name%.*}"
  # echo $file_name
  # conda config
  conda create --name $file_name
  # conda env create -f $f
  mamba env update -n $file_name --file $f
done
