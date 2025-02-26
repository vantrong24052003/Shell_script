branch_name=$1 # Nhận tên nhánh cần deploy than so dau vao tu terminal
env=$2 # Nhận môi trường (staging/production)
# neu 1 trong 2 cai rong thi no in ra
if [ -z "$branch_name" ] || [ -z "$env" ]; then 
echo "Usage: $0 <branch_name> <environment>"
exit 1
fi