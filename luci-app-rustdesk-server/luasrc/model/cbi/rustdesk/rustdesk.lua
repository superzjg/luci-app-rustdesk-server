-- 修改20250610 by superzjg@qq.com

local t = require"luci.sys"
local m

m = Map("rustdesk", translate("RustDesk 服务器"), translate("远程桌面软件服务端，配置注册/中继服务器").. "<br/>" .. [[<a href="https://github.com/rustdesk/rustdesk-server" target="_blank">]] .. translate("服务端") .. [[</a>]] .. [[<a href="https://github.com/rustdesk/rustdesk" target="_blank">]] .. translate("&nbsp;&nbsp;&nbsp;客户端") .. [[</a>]])
m:section(SimpleSection).template="rustdesk/rustdesk_status"

t=m:section(TypedSection,"rustdesk")
t.addremove = false
t.anonymous = true

t:tab("base",translate("基础设置"))
t:tab("service",translate("ID/注册服务器"))
t:tab("relay",translate("中继服务器"))

enable = t:taboption("base", Flag, "enabled", translate("启用ID服务器"))
enable.rmempty=false
enable_r = t:taboption("base", Flag, "enabled_relay", translate("启用中继服务器"))
enable_r.rmempty=false

s_log = t:taboption("base", Flag, "server_log", translate("启用输出重定向"), translate("开启后可通过顶部标签“查看输出”查看/var/log/rustdesk.log"))
s_log.default = 0

binDir = t:taboption("base", Value, "bin_dir", translate("可执行文件目录"))
binDir.datatype = "string"
binDir.default = "/usr/bin"
binDir.rmempty = false
binDir.description = translate("存放二进制文件hbbs和hbbr的目录（文件夹），结尾不要加/。注：因会产生其他文件，首次运行前建议把文件移动到一个单独子目录中")

info = t:taboption("base",DummyValue, "moreinfo", translate("注意事项"))
info.default = "需要开启的端口："
info.description = translate("默认情况下，hbbs 监听21114(tcp)，21115(tcp), 21116(tcp/udp), 21118(tcp)，hbbr 监听21117(tcp), 21119(tcp)；其中21114用于Web控制台（仅在专业版中可用），21115用作NAT类型测试，21116/UDP用作ID注册与心跳服务，21116/TCP用作TCP打洞与连接服务，21117用作中继服务, 21118和21119是为了支持网页客户端（不需要可忽略）")
firewall = t:taboption("base",ListValue, "set_firewall", translate("防火墙通信规则"), translate("检测：启动服务，无规则将建立，停止时不删除<br/>强制：启动时删除/重建，停止时删除"))
firewall:value("no", translate("-无动作-"))
firewall:value("check", translate("检测"))
firewall:value("force", translate("强制"))
firewall.default = "no"

TCPs = t:taboption("base",Value, "tcp_ports", translate("输入TCP端口"),translate("端口用空格隔开，连续端口可用-连接符。当没有设置服务器“端口”参数时，此处留空将使用默认端口放行。若设置了任一“端口”参数，程序可能自动改变其他监听端口，可以“查看输出”日志确认所有端口号，再统一填写到此处。"))
TCPs:depends("set_firewall", "check")
TCPs:depends("set_firewall", "force")
TCPs.placeholder = "21115-21119"
UDPs = t:taboption("base",Value, "udp_ports", translate("输入UDP端口"))
UDPs:depends("set_firewall", "check")
UDPs:depends("set_firewall", "force")
UDPs.placeholder = "21116"

viewkey = t:taboption("base",Button, "view_key", translate("查看key"),translate("若没有指定服务器key参数，服务启动后，可点击读取id_ed25519.pub获得key"))
viewkey.rawhtml = true
viewkey.template = "rustdesk/view_key"

del_key = t:taboption("base",Button,"del_key",translate("删除key文件"))
del_key.description = translate("删除后，重启一次服务，可自动生成新密钥")
function del_key.write()
luci.sys.exec("rm -f $(uci get rustdesk.@rustdesk[0].bin_dir)/id_ed25519*")
end

port = t:taboption("service", Value, "server_port", translate("端口"))
port.datatype = "range(1,65535)"
port.placeholder = "21116"
port.description = translate("监听端口，留空默认21116")

key = t:taboption("service",Value, "server_key", translate("key"))
key.datatype = "string"
key.description = translate("仅允许具有相同密钥的客户端。若留空，使用缺省key，位于id_ed25519.pub")

relay_server = t:taboption("service",Value, "server_relay_servers", translate("中继服务器"))
relay_server.datatype = "string"
relay_server.description = translate("默认中继服务器，以冒号分隔")

rendezvous_server = t:taboption("service",Value, "server_rendezvous_servers", translate("ID/注册服务器"))
rendezvous_server.datatype = "string"
rendezvous_server.description = translate("ID/注册服务器，以冒号分隔")

rmem = t:taboption("service",Value, "server_rmem", translate("UDP recv 缓冲"))
rmem.datatype = "range(0,52428800)"
rmem.placeholder = "0"
rmem.description = translate("UDP recv缓冲区大小（首先设置系统rmem_max），默认值0")

serial = t:taboption("service",Value, "server_serial", translate("序列号"))
serial.placeholder = "0"
serial.description = translate("配置更新序列号，默认值0")

software_url = t:taboption("service",Value,"server_software_url", translate("下载链接"))
software_url.datatype = "string"
software_url.description = translate("最新版本RustDesk软件的下载url")

relay_port = t:taboption("relay", Value, "relay_port", translate("端口"))
relay_port.datatype = "range(1,65535)"
relay_port.placeholder = "21117"
relay_port.description = translate("监听端口，留空默认21117")

relay_key = t:taboption("relay",Value, "relay_key", translate("key"))
relay_key.datatype = "string"
relay_key.description = translate("仅允许具有相同密钥的客户端。若留空，使用缺省key，位于id_ed25519.pub")

return m
