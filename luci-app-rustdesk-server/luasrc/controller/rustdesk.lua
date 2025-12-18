module("luci.controller.rustdesk", package.seeall)

function index()
	entry({"admin", "services", "rustdesk-server"},firstchild(), _("RustDesk 服务器")).dependent = false
	entry({"admin", "services", "rustdesk-server", "basic"}, cbi("rustdesk/rustdesk"), _("RustDesk 服务器"), 1).leaf = true
	entry({"admin", "services", "rustdesk-server", "log"}, cbi("rustdesk/log"), _("查看输出"), 2).leaf = true
	entry({"admin", "services", "rustdesk-server", "get_log"}, call("get_log")).leaf = true
	entry({"admin", "services", "rustdesk-server", "clear_log"}, call("clear_log")).leaf = true
	entry({"admin", "services", "rustdesk-server", "status"}, call("status")).leaf = true
	entry({"admin", "services", "rustdesk-server", "view_key"}, call("view_key")).leaf = true
end

function status()
	local e={}
	e.running=luci.sys.call("pidof hbbs > /dev/null")==0
	e.relay_running=luci.sys.call("pidof hbbr > /dev/null")==0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end

function get_log()
	luci.http.write(luci.sys.exec("cat /var/log/rustdesk.log"))
end

function clear_log()
	luci.sys.call("cat /dev/null > /var/log/rustdesk.log")
end

function view_key()
	local pubKey = luci.sys.exec("cat $(uci get rustdesk.@rustdesk[0].bin_dir)/id_ed25519.pub")

	luci.http.prepare_content("application/json")
	luci.http.write_json({pubKey = pubKey})
end
