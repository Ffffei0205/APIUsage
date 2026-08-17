/**
 * 项目名称: ApiUsage
 * 文件名称: LoadingFailedView
 * 创建时间: 2026-08-11 21:02
 * 创建人：  @author Ffffei
 * 文件描述: TODO
 */


// LoadingFailedView.ets —— 加载失败，点击重试
@Builder
export function LoadingFailedView(breakpoint: WidthBreakpoint, handleReload?: () => void) {
  Column() {
    // Image($r('app.media.ic_failure'))   // 失败图标
    //   .width(new BreakpointType({ ... }).getValue(breakpoint))
    //   .aspectRatio(1)
    Text($r('app.string.server_error')) // “服务器错误”
      .fontColor($r('sys.color.font_tertiary'))
  }
  .onClick(() => handleReload?.())      // 整页可点击 → 触发重试
  .width('100%')
  .height('100%')
  .justifyContent(FlexAlign.Center)
}