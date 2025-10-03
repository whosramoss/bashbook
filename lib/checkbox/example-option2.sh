echo "example option 2"
file="temporary-example-2.txt"
sleep 1
touch "$file"
echo "File '$file' created."
sleep 1
rm -f "$file"
echo "File '$file' deleted."
sleep 1
echo "----------------"