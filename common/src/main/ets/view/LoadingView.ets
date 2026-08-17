/**
 * 项目名称: ApiUsage
 * 文件名称: LoadingView
 * 创建时间: 2026-08-11 21:02
 * 创建人：  @author Ffffei
 * 文件描述: 默认加载中组件，任何地方都可以使用
 */


// LoadingView.ets —— 加载中
@Builder
export function LoadingView(breakpoint: WidthBreakpoint) {
  Column() {
    Row() {
      LoadingProgress()          // 系统转圈组件
    }
    .width(30)
    // .width(new BreakpointType({
    //   sm: $r('app.float.loading_size_sm'),
    //   md: $r('app.float.loading_size_md'),
    //   lg: $r('app.float.loading_size_md'),
    // }).getValue(breakpoint))
    .aspectRatio(1)

    Text($r('app.string.loading'))     // “加载中”文字
      .fontSize($r('sys.float.Body_M'))
      .fontColor($r('sys.color.font_secondary'))
      .margin($r('sys.float.padding_level12'))
  }
  .alignItems(HorizontalAlign.Center)
  .justifyContent(FlexAlign.Center)
  .backgroundColor($r('sys.color.background_secondary'))
  .height('100%')
  .width('100%')
}