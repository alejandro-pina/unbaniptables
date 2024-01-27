# Unban-IPtables

## Description
This Bash script helps to unban a specific IP address in iptables. It provides a quick overview of the IP bans, including line numbers, the associated chain, and methods to unban.

## Usage
```bash
./unban-iptables.sh <IP_ADDRESS>
```

## Features
1. First list item
   - View detailed information about the banned IP addresses.
   - Three methods to unban the IP using iptables:
     1. Remove the corresponding rule using sudo iptables -D <chain-name> <rule-number>.
     2. Manually edit iptables configuration to remove the rule.
     3. Adjust iptables rules to allow the specific IP.

## Instructions
1. Run the script with the target IP address as a parameter.
2. Review the information about the banned IP.
3. Choose a method to unban the IP.

## Commands
- To check the state ban:
```bash
iptables -L -n --line-numbers | grep -E -n <IP_ADDRESS>
```
## Automatic Unban
- Run the script with the following command:
```bash
./unban-iptables.sh <IP_ADDRESS>
```
## Note

- Ensure you have the necessary privileges to modify iptables rules.

## License

This script is released under the [MIT](https://choosealicense.com/licenses/mit/)
