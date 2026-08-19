import { CommonConstants } from "common";

/**
 * 项目名称: ApiUsage
 * 文件名称: BalanceStatusCard
 * 创建时间: 2026-08-15 22:58
 * 创建人：  @author Ffffei
 * 文件描述: 账户是否可以用组件
 */
@Component
export struct BalanceStatusCard {
  @Prop isAvailable: boolean = false; // 账户是否可用
  @Prop savedKeyMasked: string = '';
  @Prop refreshedAtText: string = '';
  onRefresh?: () => void;

  build() {
    Column({ space: $r('sys.float.padding_level4') }) {
      Row() {
        Column({ space: $r('sys.float.padding_level1') }) {
          Text($r('app.string.current_api_key'))
            .fontSize($r('sys.float.Body_S'))
            .fontColor($r('sys.color.font_primary'))
          Text(this.savedKeyMasked)
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.font_secondary'))
            .fontWeight(FontWeight.Medium)
        }
        .alignItems(HorizontalAlign.Start)

        Button() {
          SymbolGlyph($r('sys.symbol.arrow_clockwise'))
            .fontSize($r('sys.float.Body_M'))
            .fontColor([$r('sys.color.font_primary')])
            .fontWeight(FontWeight.Medium)
        }
          .backgroundColor($r('sys.color.comp_background_secondary'))
          .borderRadius($r('sys.float.corner_radius_level12'))
          .height(32)
          .width(32)
          .onClick(() => {
            this.onRefresh?.();
          })
      }
      .width(CommonConstants.FULL_PERCENT)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      Divider()
        .color($r('app.color.divider_color'))

      Row() {
        Row({ space: $r('sys.float.padding_level2') }) {
          Text('\u25CF')
            .fontSize($r('sys.float.Body_M'))
            .fontColor(this.isAvailable ? $r('app.color.success_color') : $r('app.color.error_color'))
          Text(this.isAvailable ? $r('app.string.account_available') : $r('app.string.account_unavailable'))
            .fontSize($r('sys.float.Body_S'))
            .fontColor(this.isAvailable ? $r('app.color.success_color') : $r('app.color.error_color'))
            .fontWeight(FontWeight.Medium)
        }

        if (this.refreshedAtText.length > 0) {
          Text($r('app.string.last_refreshed_at', this.refreshedAtText))
            .fontSize($r('sys.float.Body_S'))
            .fontColor($r('sys.color.font_secondary'))
        }
      }
      .width(CommonConstants.FULL_PERCENT)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width(CommonConstants.FULL_PERCENT)
    .padding($r('sys.float.padding_level8'))
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('sys.float.corner_radius_level12'))
  }
}
