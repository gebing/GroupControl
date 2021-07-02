## 群控相关数据的生成

### 1、安卓代理设置

参考文章：[https://android.stackexchange.com/questions/217248/how-to-set-wi-fi-https-proxy-not-http-via-adb-shell](https://android.stackexchange.com/questions/217248/how-to-set-wi-fi-https-proxy-not-http-via-adb-shell)

#### 设置全局代理

修改`http_proxy`的设置值后，由于`ConnectivityService`监听`http_proxy`的改变，代理配置自动生效。代理配置生效后，系统会自动修改以下的参数设置值：`global_http_proxy_host`/`global_http_proxy_port`/`global_http_proxy_exclusion_list`。

```
settings put global http_proxy <host>:<port>
```

#### 清除全局代理

```
settings put global http_proxy :0
```

#### 查询全局代理

```
settings get global http_proxy
settings get global global_http_proxy_host
settings get global global_http_proxy_port
settings get global global_http_proxy_exclusion_list
settings get global global_proxy_pac_url
```

#### 删除全局代理配置

```
settings delete global http_proxy
settings delete global global_http_proxy_host
settings delete global global_http_proxy_port
settings delete global global_http_proxy_exclusion_list
settings delete global global_proxy_pac_url
```

注意：删除`http_proxy`的配置值，不能将系统的全局代理设置为不使用代理。

### 2、代理的黑/白名单

#### 黑名单：即需要走代理的国外域名列表

- 全列表：[https://github.com/gfwlist/gfwlist](https://github.com/gfwlist/gfwlist)

下载地址：`https://cdn.jsdelivr.net/gh/gfwlist/gfwlist@master/gfwlist.txt`

- Tiny版本：[https://github.com/gfwlist/tinylist](https://github.com/gfwlist/tinylist)

下载地址：`https://cdn.jsdelivr.net/gh/gfwlist/tinylist@master/tinylist.txt`

#### 白名单：即不需要走代理的国内域名列表

- chnlist：[https://github.com/PaPerseller/chn-iplist](https://github.com/PaPerseller/chn-iplist)

#### 生成代理PAC文件的工具：

- genpac：[https://github.com/JinnLynn/genpac](https://github.com/JinnLynn/genpac)

```
genpac --pac-proxy <proxy> --output=<output_pac> --gfwlist-url=<gfw_url> --user-rule-from=<local_rule>
其中：
proxy的可选值为：'DIRECT'、'PROXY host:port'、'SOCKS5 host:port'
```

- pac_generator：[https://github.com/Svtter/pac_generator](https://github.com/Svtter/pac_generator)

- pactester：[https://github.com/manugarg/pacparser](https://github.com/manugarg/pacparser)


start:
iptables -t nat -N REDSOCKS
iptables -t nat -A REDSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A REDSOCKS -d 192.168.0.0/16 -j RETURN
iptables -t nat -A REDSOCKS -d 192.168.3.215 -j RETURN
iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345
iptables -t nat -A OUTPUT -p tcp -j REDSOCKS


stop:
iptables -t nat -D OUTPUT -p tcp -j REDSOCKS
iptables -t nat -F REDSOCKS
iptables -t nat -X REDSOCKS


list:
iptables -t nat -L -n --line-numbers