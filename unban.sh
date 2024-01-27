#!/bin/bash
if [ -z "$1" ]; then
  echo "You must provide an IP address as a parameter."
  exit 1
fi
specific_ip="$1"
ip_lines=$(sudo iptables -L -n --line-numbers | grep -E -n " $specific_ip ")
ls_chain=()
echo ""
echo -e " ┌────────┬────────┬────────────────────────┬────────────────────────┐"
echo -e " │   No.  │  Line  |           IP           │   Unban In (Chain)     │"
echo -e " ├────────┼────────┼────────────────────────┼────────────────────────┤"
while IFS=: read -r line_num line_content; do
  rule_num=$(echo "$line_content" | awk '{print $1}')
  current_count=$((line_num - 1 - rule_num))
  chain_line_num=$((current_count))
  chain=$(sudo iptables -L -n --line-numbers | awk -v line_num="$chain_line_num" 'NR==line_num {print $2}')
  printf " │ %5d  │ %5d  │     %-15s    │  %-20s  │\n" "$rule_num" "$chain_line_num"  "$specific_ip" "$chain"
  ls_chain[${#ls_chain[@]}]="$chain $rule_num"
  ls_cmd_unban=()
done <<< "$ip_lines"
echo " └────────┴────────┴────────────────────────┴────────────────────────┘"  # Line below each IP
echo ""
echo " ┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐"
echo " |  Three methods to unban the IP using iptables:                                                                 |"
echo " |  1. Edit iptables rules and remove the corresponding rule using 'sudo iptables -D <chain-name> <rule-number>'  |"
echo " |  2. Manually edit iptables configuration to remove the rule.                                                   |"    
echo " |  3. Adjust iptables rules to allow the specific IP.                                                            |"
echo " ├────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤"
for chain_and_number in "${ls_chain[@]}"; do
  ls_cmd_unban[${#ls_cmd_unban[@]}]="sudo iptables -D $chain_and_number"
  printf " |  sudo iptables -D %-60s                                 |\n" "$chain_and_number" 
done
echo " └────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘"
echo ""
echo " ┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐"
echo " |  Check state ban with cmd:                                                                                     |"
echo " |  iptables -L -n --line-numbers | grep -E -n $specific_ip                                                       |"                                                      
echo " └────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘"
echo ""
exec_unban () {
  for ls_cmd in "${ls_cmd_unban[@]}"; do
    echo "Exec: $ls_cmd"
    $ls_cmd
  done
}
while true; do
  read -p "Do you want to unban the IP of all jails automatically? (y/n): " yn
  case $yn in
    [Yy]|[Yy][Ee][Ss]) exec_unban; exit 0;;
    [Nn]|[Nn][Oo]) echo "Exit..."; break; exit 0;;
    *) echo "Plis, write 'yes' or 'no'.";;
  esac
done

