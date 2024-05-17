# linux_setup
Scripts and configs for a GNU/Linux system

There are also some that can work on macOS.

### How to add color to outputs:

With `echo -e` you can use escape characters:

```bash
echo "TEXT COLOR"
echo -e "\e[1;31m RED \e[0m"
echo -e "\e[1;32m GREEN \e[0m"
echo -e "\e[1;33m YELLOW \e[0m"
echo -e "\e[1;34m BLUE \e[0m"
echo -e "\e[1;35m MAGENTA \e[0m"
echo -e "\e[1;36m CYAN \e[0m"
echo ""
echo "BACKGROUND COLOR"
echo -e "\e[1;41m RED \e[0m"
echo -e "\e[1;42m GREEN \e[0m"
echo -e "\e[1;43m YELLOW \e[0m"
echo -e "\e[1;44m BLUE \e[0m"
echo -e "\e[1;45m MAGENTA \e[0m"
echo -e "\e[1;46m CYAN \e[0m"
```
