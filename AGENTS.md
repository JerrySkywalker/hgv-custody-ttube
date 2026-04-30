# AGENTS.md

本仓库是博士论文 MATLAB 工程的重构版本。

## 基本规则

1. 只在当前新仓库内修改文件。
2. 旧工程 C:\Dev\src\hgv-custody-inversion-scheduling 只作为只读参考，禁止修改。
3. 默认不运行长耗时实验。
4. MATLAB MCP 仅用于环境检查、静态检查、smoke test 和小规模验证。
5. 计算核心、绘图、STK 接口、C++ 导出接口需要逐步分层实现。
6. 每次修改应小步进行，并说明影响范围。
