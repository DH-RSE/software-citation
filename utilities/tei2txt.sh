folder=$1

for file in $(ls ${folder}/*.xml);
do 
    [ -f "$file" ] || break
    echo Processing ${file}
    s=$(basename $file .xml)
    #echo Output ${folder}/${s}.txt
    curl -o "${folder}/${s}.txt" -F upload=@"${file}" 'https://teigarage.tei-c.de/ege-webservice/Conversions/TEI%3Atext%3Axml/txt%3Atext%3Aplain/conversion?properties=%3Cconversions%3E%3Cconversion%20index=%220%22%3E%3Cproperty%20id=%22oxgarage.getImages%22%3Efalse%3C/property%3E%3Cproperty%20id=%22oxgarage.getOnlineImages%22%3Efalse%3C/property%3E%3Cproperty%20id=%22oxgarage.lang%22%3Een%3C/property%3E%3Cproperty%20id=%22oxgarage.textOnly%22%3Etrue%3C/property%3E%3Cproperty%20id=%22pl.psnc.dl.ege.tei.profileNames%22%3Edefault%3C/property%3E%3C/conversion%3E%3C/conversions%3E'
done
