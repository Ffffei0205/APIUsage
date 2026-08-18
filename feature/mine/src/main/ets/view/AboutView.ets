/**
 * 项目名称: ApiUsage
 * 文件名称: AboutView
 * 文件描述: 关于和反馈半模态内容
 */

import { CommonConstants } from 'common';
import { AboutItemCard } from '../components/AboutItemCard';
import { AboutState } from '../viewmodel/AboutState';
import { AboutVM, InitializeAboutEvent } from '../viewmodel/AboutVM';

@Component
export struct AboutView {
  private viewModel: AboutVM = AboutVM.getInstance();
  @State aboutState: AboutState = this.viewModel.getState();

  aboutToAppear(): void {
    this.viewModel.sendEvent(new InitializeAboutEvent());
  }

  build() {
    Column() {
      Image($r('app.media.startIcon'))
        .draggable(false)
        .width($r('app.float.about_image_size'))
        .height($r('app.float.about_image_size'))
        .borderRadius($r('sys.float.corner_radius_level8'))

      Text($r('app.string.app_name'))
        .fontSize($r('sys.float.Title_S'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))
        .margin({ top: $r('sys.float.padding_level4') })

      AboutItemCard({ appVersion: this.aboutState.appVersion })
        .margin({ top: $r('sys.float.padding_level16') })
    }
    .width(CommonConstants.FULL_PERCENT)
    .padding({
      left: $r('sys.float.padding_level8'),
      right: $r('sys.float.padding_level8'),
      top: $r('sys.float.padding_level8'),
      bottom: $r('sys.float.padding_level16'),
    })
  }
}

@Builder
export function AboutViewBuilder() {
  AboutView()
}
