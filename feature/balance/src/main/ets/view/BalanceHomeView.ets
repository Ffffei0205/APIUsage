/**
 * 项目名称: ApiUsage
 * 文件名称: BalanceHomeView
 * 创建时间: 2026-08-14
 * 创建人：  @author Ffffei
 * 文件描述:
 *        余额页面的导航壳，是最外层，不写任何业务，
 *        它只关注这个 tab 本身，同时也是路由导航的根
 */
import { PageContext, PageEnum, StorageKey } from "common";
import { HdsNavigation, HdsNavigationTitleMode, HdsTabsController } from "@kit.UIDesignKit";
import { HomeContentParams } from "commonbusiness";


@Component({ freezeWhenInactive: true })
export struct BalanceHomeView {
  @StorageLink(StorageKey.BALANCE_PAGE_CONTEXT) balancePageContext: PageContext =
    AppStorage.get<PageContext>(StorageKey.BALANCE_PAGE_CONTEXT) ?? new PageContext();
  scroller: Scroller = new Scroller();
  homeTabController: HdsTabsController = new HdsTabsController();

  aboutToAppear(): void {
    this.balancePageContext.replacePage({
      routerName: PageEnum.BALANCE_VIEW,
      param: {
        scroller: this.scroller,
        homeTabController: this.homeTabController
      } as HomeContentParams
    }, false)
  }

  build() {
    HdsNavigation(this.balancePageContext.navPathStack) {
    }
    .hideBackButton(true)
    .hideTitleBar(true)
    .titleMode(HdsNavigationTitleMode.MINI)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
    .width('100%')
    .height('100%')
  }
}
