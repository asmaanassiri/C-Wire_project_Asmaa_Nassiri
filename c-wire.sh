#!/bin/bash
#######################################################
#  File Name: c-wire.sh
#  Author: Asmaa NASSIRI
#  Version: 1.0
#  Usage: ./c-wire.sh
#######################################################

# Vérifier les arguments
if [ "$1" == "-h" ] || [ $# -lt 3 ]; then
  echo "Usage: $0 <data_path> <station_type> <consumer_type> [<central_id>]"
  exit 1
fi

DATA_PATH=$1
STATION_TYPE=$2
CONSUMER_TYPE=$3
CENTRAL_ID=$4

# Valider le type de station
if [[ ! "$STATION_TYPE" =~ ^(hvb|hva|lv)$ ]]; then
  echo "Error: Invalid station type ($STATION_TYPE). Must be one of: hvb, hva, lv."
  exit 1
fi

# Valider le type de consommateur
if [[ ! "$CONSUMER_TYPE" =~ ^(comp|indiv|all)$ ]]; then
  echo "Error: Invalid consumer type ($CONSUMER_TYPE). Must be one of: comp, indiv, all."
  exit 1
fi

# Transformer les noms pourqu'ils soient pareils aux noms des colonnes
if [ "$STATION_TYPE" == "hvb" ]; then
    STATION_TYPE="HV-B Station"
elif [ "$STATION_TYPE" == "hva" ]; then
    STATION_TYPE="HV-A Station"
elif [ "$STATION_TYPE" == "lv" ]; then
    STATION_TYPE="LV Station"
fi

if [ "$CONSUMER_TYPE" == "comp" ]; then
    CONSUMER_TYPE="Company"
elif [ "$CONSUMER_TYPE" == "indiv" ]; then
    CONSUMER_TYPE="Individual"
fi 

                                             
# Vérifier et compiler le prgramme C
if [ ! -f "codeC/main" ]; then
  echo "Compiling C program..."
  make -C codeC
  if [ $? -ne 0 ]; then
    echo "Error: Failed to compile C program."
    exit 1
  fi
fi

# Créer le répertoire s'il n'existe pas
mkdir -p tmp graphs
# Clean tmp directory
rm -f tmp/*


FILTERED_DATA="tmp/filtered_data.csv"
# Print the header first
echo "Powernanplant;$STATION_TYPE;$CONSUMER_TYPE;Capacity;Load" > "$FILTERED_DATA"

awk -F';' -v STATION_TYPE = "$STATION_TYPE" -v CONSUMER_TYPE = "$CONSUMER_TYPE" ' 
NR==1 {
    for(i=1; i<=NF; i++) 
        if($i == STATION_TYPE) 
            col1 = i 
    for(i=1; i<=NF; i++) 
        if($i == CONSUMER_TYPE) 
            col2 = i
} 
NR > 1 {
    if ($col1 != "-" && $col2 != "-") 
        print $1 ";" $col1 ";" $col2";" $7";"$8  } ' "$DATA_PATH" >> "$FILTERED_DATA"

if [[ "$CONSUMER_TYPE" == "all" && "$col1" != "-" ]]; then  
  print $1 ";" $col1 ";" $5";"$6";" $7";"$8"  } ' "$DATA_PATH" >> "$FILTERED_DATA"
  
# =========================================================================
# Exécuter le programme C
codeC/main $FILTERED_DATA $STATION_TYPE $CONSUMER_TYPE $CENTRAL_ID

# Vérifier si il s agit des stations LV
if [[ "$STATION_TYPE" == "lv" && "$CONSUMER_TYPE" == "all" ]]; then
  # Trier et extraire les tops 10 et 10 les plus basses.
  echo "Extracting top 10 and bottom 10 LV stations by consumption..."
  head -n 10 tmp/lv_all_sorted.csv > tmp/lv_top_10.csv
  tail -n 10 tmp/lv_all_sorted.csv > tmp/lv_bottom_10.csv
  
  # Combine the top 10 and bottom 10 for the graph
  cat tmp/lv_top_10.csv tmp/lv_bottom_10.csv > tmp/lv_minmax.csv
  
  # Genérer les graphes

# Assurez-vous que le répertoire du graphique existe
if [ ! -d "graphs" ]; then
  mkdir -p graphs
fi
# S assurer que le fichier input existe.
if [ ! -f "tmp/lv_minmax.csv" ]; then
  echo "Error: tmp/lv_minmax.csv not found."
  exit 1
fi

# Exécuter les commandes Gnuplot
gnuplot <<EOF
    set terminal png size 1024,768
    set output "graphs/lv_all_minmax.png"
    set datafile separator ","
    set key autotitle columnhead
    set style data histogram
    set style histogram cluster gap 1
    set boxwidth 0.9
    set style fill solid 1.0 border -1
    set xlabel " LV Station ID "
    set ylabel " Consumption \(kWh\) "
    set title " Top 10 and Bottom 10 LV Stations by Consumption "
    set xtics rotate
    plot "tmp/lv_minmax.csv" using 3:xtic(1) title " Consumption "
EOF


echo "Plot saved as graphs/lv_all_minmax.png"
echo " Graph for top 10 and bottom 10 LV stations saved as graphs/lv_all_minmax.png "
echo " Processing completed. Check the tmp/ and graphs/ directories for results. "

# Fin du programme 