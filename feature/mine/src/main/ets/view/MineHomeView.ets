/**
 * 项目名称: ApiUsage
 * 文件名称: MineHomeView.ets
 * 创建时间: 2026-08-12 21:32
 * 创建人：  @author Ffffei
 * 文件描述:
 *        我的页面的导航壳，是最外层，不写任何业务，
 *        它只关注这个tab本身，同时这也是路由导航的根
 */
import { PageContext, PageEnum, StorageKey } from "common";
import { HdsNavigation, HdsNavigationTitleMode, HdsTabsController } from "@kit.UIDesignKit";
import { HomeContentParams } from "commonbusiness";


@Component({ freezeWhenInactive: true })
export struct MineHomeView {
  @StorageLink(StorageKey.MINE_PAGE_CONTEXT) minePageContext: PageContext =
    AppStorage.get<PageContext>(StorageKey.MINE_PAGE_CONTEXT) ?? new PageContext();
  scroller: Scroller = new Scroller();
  homeTabController: HdsTabsController = new HdsTabsController();

  aboutToAppear(): void {
    this.minePageContext.replacePage({
      routerName: PageEnum.MINE_VIEW,
      param: {
        scroller: this.scroller,
        homeTabController: this.homeTabController
      } as HomeContentParams
    },false)
  }

  build() {
    HdsNavigation(this.minePageContext.navPathStack) {
    }
    .hideBackButton(true)
    .hideTitleBar(true)
    .titleMode(HdsNavigationTitleMode.MINI)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
    .width('100%')
    .height('100%')
  }
}