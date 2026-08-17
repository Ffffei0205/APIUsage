/**
 * 项目名称: ApiUsage
 * 文件名称: MainPage
 * 创建时间: 2026-08-14 21:50
 * 创建人：  @author Ffffei
 * 文件描述: TODO
 */
import { HomeView } from 'abilitycommon'
import { CommonConstants } from 'common'


@Builder
export function MainPageBuilder() {
  MainPage()
}

@Component
struct MainPage {
  build() {
    NavDestination() {
      HomeView()
    }
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
    .transition(TransitionEffect.OPACITY)
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
    // .onBackPressed(() => {
    //   return true
    // })
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
  }
}
