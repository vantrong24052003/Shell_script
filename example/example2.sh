num1=$1
num2=$2

per=$(((num1 + num2)*2)) 
area=$((num1 * num2))    

if [ "$num1" -ne 0 ] && [ "$num2" -ne 0 ]; then
echo "Area = $area, Per  = $per"
exit1
fi