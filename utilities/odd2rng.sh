folder=$1

for file in $(ls ${folder}/*.odd);
do 
    [ -f "$file" ] || break
    echo Processing ${file}
    s=$(basename $file .odd)
    #echo Output ${folder}/${s}.txt
curl -o "${folder}/${s}.rng" -F upload=@"${file}" 'https://teigarage.tei-c.de/ege-webservice/Conversions/ODD%3Atext%3Axml/ODDC%3Atext%3Axml/relaxng%3Aapplication%3Axml-relaxng'
done
