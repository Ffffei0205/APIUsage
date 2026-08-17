/**
 * 项目名称: ApiUsage
 * 文件名称: SplashPage
 * 创建时间: 2026-08-14 21:48
 * 创建人：  @author Ffffei
 * 文件描述: 启动页，几秒后跳转至主页
 */

import { HdsNavigation } from '@kit.UIDesignKit';
import { PageContext, StorageKey } from 'common';
import { SplashView } from 'abilitycommon';

@Entry
@Component
struct SplashPage {
  @StorageLink(StorageKey.HOME_PAGE_CONTEXT) pageContext: PageContext =
    AppStorage.get<PageContext>(StorageKey.HOME_PAGE_CONTEXT) ?? new PageContext();

  build() {
    HdsNavigation(this.pageContext.navPathStack) {
      SplashView()
    }
    .hideTitleBar(true)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
    .width('100%')
    .height('100%')
  }
}