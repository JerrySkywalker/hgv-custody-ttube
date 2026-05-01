# MATLAB MCP 项目级配置说明

生成时间：2026-04-30 09:57:49 +08:00

## 1. 项目路径

```text
C:\Dev\src\hgv-custody-ttube
```

## 2. 当前 MATLAB MCP 配置

MATLAB MCP Core Server：

```text
C:\Dev\mcp\servers\matlab-mcp-core-server\bin\matlab-mcp-core-server.exe
```

MATLAB 安装目录：

```text
C:\Program Files\MATLAB\R2025b
```

MATLAB session mode：

```text
new
```

MATLAB display mode：

```text
nodesktop
```

是否在 MCP Server 启动时立即初始化 MATLAB：

```text
false
```

是否设置 MATLAB 初始工作目录：

```text
True
```

项目级 Codex 配置文件：

```text
C:\Dev\src\hgv-custody-ttube\.codex\config.toml
```

## 3. 使用方法

进入项目目录：

```powershell
cd "C:\Dev\src\hgv-custody-ttube"
codex
```

如果 Codex 提示是否信任该项目，请选择信任。

进入 Codex 后执行：

```text
/mcp
```

确认 matlab server 已出现。

然后可以输入：

```text
请检测 MATLAB 版本和已安装工具箱。
```

## 4. 推荐第一次任务

```text
请使用 MATLAB MCP 对当前工程做只读环境检查，不要修改任何文件。

要求：
1. 检测 MATLAB 版本和工具箱；
2. 检查当前工作目录；
3. 尝试执行 startup('force', true)；
4. 使用 check_matlab_code 检查 startup.m；
5. 不运行任何大型实验；
6. 汇报 MATLAB 是否可用、路径链是否正常、下一步建议。
```

## 5. 注意事项

1. 本项目使用项目级 .codex/config.toml，不依赖全局 Codex MCP 配置。
2. 不建议把 MATLAB MCP 写入 %USERPROFILE%\.codex\config.toml。
3. 长耗时仿真实验应先由 Codex 生成命令，再由用户确认是否执行。
4. 如果需要连接已经打开的 MATLAB，请改用 --matlab-session-mode=existing，并在 MATLAB 中运行 shareMATLABSession()。
5. 如果项目移动了位置，请重新运行本脚本，以刷新 --initial-working-folder。

## 6. 当前生成的 MCP 片段

```toml
[mcp_servers.matlab]
command = "C:\\Dev\\mcp\\servers\\matlab-mcp-core-server\\bin\\matlab-mcp-core-server.exe"
args = [
  "--matlab-root=C:\\Program Files\\MATLAB\\R2025b",
  "--matlab-display-mode=nodesktop",
  "--matlab-session-mode=new",
  "--initialize-matlab-on-startup=false",
  "--disable-telemetry=true",
  "--initial-working-folder=C:\\Dev\\src\\hgv-custody-ttube"
]
startup_timeout_sec = 60
tool_timeout_sec = 600
enabled_tools = [
  "detect_matlab_toolboxes",
  "check_matlab_code",
  "evaluate_matlab_code",
  "run_matlab_file",
  "run_matlab_test_file"
]
```
