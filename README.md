# tools-stuff

## dlcore.sh
更新、下载v2ray-core
```bash
./dlcore.sh
```
`vim ~/.zshrc` 设置别名

```bash
alias fanqiang="export ALL_PROXY=socks5://127.0.0.1:1080;export HTTP_PROXY=socks5://127.0.0.1:1080;export HTTPS_PROXY=socks5://127.0.0.1:1080"
alias bufan="unset ALL_PROXY;unset HTTP_PROXY;unset HTTPS_PROXY"
alias v2raygogogo="nohup ~/repos/tools-stuff/v2ray-macos/v2ray -config ~/OneDrive/tools/config.json >/dev/null 2>&1 &"

# 你懂的 嘿嘿嘿
alias teleimgupdate='find ~/Library/Group\ Containers/6N38VWS5BX.ru.keepcoder.Telegram/account-{一串id}/postbox/media -name "*.jpg" |grep -v "partial.jpg" |xargs -I % cp % ~/Pictures/tele'
```