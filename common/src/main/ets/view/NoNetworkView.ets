/**
 * 项目名称: ApiUsage
 * 文件名称: NoNetworkView
 * 创建时间: 2026-08-11 21:03
 * 创建人：  @author Ffffei
 * 文件描述: TODO
 */

// NoNetworkView.ets —— 无网络（核心部分）
@Builder
export function NoNetworkView(breakpoint: WidthBreakpoint, handleReload?: () => void) {
  Column() {
    // Image($r('app.media.ic_failure'))
    //   .width(new BreakpointType({ ... }).getValue(breakpoint))
    //   .aspectRatio(1)
    Text($r('app.string.network_error'))   // “网络异常”
    Button($r('app.string.network_setting'))  // “网络设置”按钮 → 跳系统设置
      .onClick(() => {
        // 构造 Want 跳系统设置页（wifi）
      })
  }
  .onClick(() => handleReload?.())
}