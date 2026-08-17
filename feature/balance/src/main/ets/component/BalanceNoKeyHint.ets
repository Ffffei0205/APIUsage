/**
 * 项目名称: ApiUsage
 * 文件名称: BalanceNoKeyHint
 * 创建时间: 2026-08-15 23:00
 * 创建人：  @author Ffffei
 * 文件描述: 未配置
 */

@Component
export struct BalanceNoKeyHint {
  handleGoSetting?: () => void;   // 父级传入的“去设置”回调

  build() {
    Column() {
      Text($r('app.string.no_api_key_hint'))
        .fontSize(16)
        .fontColor($r('app.color.secondary_color'))
        .margin({ bottom: 16 })
      Button($r('app.string.go_to_settings'))
        .backgroundColor($r('app.color.primary_color'))
        .fontColor(Color.White)
        .borderRadius(8)
        .onClick(() => {
          this.handleGoSetting?.();   // 有回调才执行
        })
    }
    .width('100%')
    .padding(16)
    .margin({ top: 40 })
    .justifyContent(FlexAlign.Center)
  }
}