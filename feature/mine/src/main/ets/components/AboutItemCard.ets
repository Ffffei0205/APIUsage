/**
 * 项目名称: ApiUsage
 * 文件名称: AboutItemCard
 * 文件描述: 关于和反馈页面的信息卡片
 */

@Component
export struct AboutItemCard {
  @Prop appVersion: string = '';

  @Builder
  infoItem(title: ResourceStr, content: ResourceStr) {
    Row() {
      Column() {
        Text(title)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_primary'))
        Text(content)
          .margin({ top: $r('sys.float.padding_level2') })
          .fontWeight(FontWeight.Regular)
          .fontSize($r('sys.float.Subtitle_S'))
          .fontColor($r('sys.color.font_secondary'))
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height($r('app.float.about_item_card_height'))
    .padding({
      left: $r('sys.float.padding_level6'),
      right: $r('sys.float.padding_level6'),
    })
  }

  build() {
    Column() {
      this.infoItem($r('app.string.version_information'), this.appVersion)

      Divider()
        .color($r('sys.color.comp_divider'))
        .margin({
          left: $r('sys.float.padding_level6'),
          right: $r('sys.float.padding_level6'),
        })

      this.infoItem($r('app.string.feedback_email'), $r('app.string.feedback_email_value'))
    }
    .width('100%')
    .borderRadius($r('sys.float.corner_radius_level7'))
    .backgroundColor($r('sys.color.comp_background_list_card'))
  }
}
