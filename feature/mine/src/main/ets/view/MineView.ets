/**
 * 项目名称: ApiUsage
 * 文件名称: MineView
 * 创建时间: 2026-08-12 22:18
 * 创建人：  @author Ffffei
 * 文件描述: ‘我的’页面的具体内容代码
 */
import { hdsMaterial, HdsNavDestination, HdsTabsController, ScrollEffectType } from "@kit.UIDesignKit"
import { CommonConstants, GlobalInfoModel, hdsListItem, PageContext, PageEnum, StorageKey } from "common"
import { BaseHomeEventType, HomeContentParams, InitializeParam, OffsetParam } from "commonbusiness";
import { MineListItem } from "../components/MineListItem";
import { BuilderEnum, ListGroup, MineItem, MinePageState } from "../viewmodel/MinePageState"
import { MineEventType, MinePageVM } from "../viewmodel/MinePageVM";

@Builder
export function MineViewBuilder() {
  MineView()
}

@Component
export struct MineView {
  @State viewModel: MinePageVM = MinePageVM.getInstance();
  @State minePageState: MinePageState = this.viewModel.getState();
  @StorageProp(StorageKey.GLOBAL_INFO) globalInfoModel: GlobalInfoModel =
    AppStorage.get(StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();
  @StorageLink(StorageKey.MINE_PAGE_CONTEXT) minePageContext: PageContext =
    AppStorage.get<PageContext>(StorageKey.MINE_PAGE_CONTEXT) ?? new PageContext();
  homeTabController: HdsTabsController = new HdsTabsController();
  scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.viewModel.sendEvent<null>({ type: MineEventType.INIT_DATA, param: null });
  }

  @Builder
  mineContentViewBuilder() {
    Scroll(this.minePageState.scroller) {
      Column({ space: CommonConstants.SPACE_12 }) {
        ForEach(this.minePageState.listItemData, (groupData: ListGroup) => {
          Flex({
            direction: FlexDirection.Row,
            wrap: FlexWrap.Wrap
          }) {
            ForEach(groupData.group, (item: MineItem, index: number) => {
              if (item.type === BuilderEnum.LOGIN_ITEM) {
                // 你的登录头部（先放占位）
                MineListItem({
                  prefixResource: item.symbolSrc,
                  title: item.textContent,
                  handleClickAction: () => {
                    if (item.onclick) {
                      item.onclick()
                    } else {

                    }
                  }
                })
              } else {
                //具体页面
                Column() {
                  if (index > 0) {
                    Divider()
                      .color($r('sys.color.comp_background_tertiary'))
                      .width(CommonConstants.FULL_PERCENT)
                      .padding({ left: CommonConstants.SPACE_40, right: $r('sys.float.padding_level6') })
                  }
                  hdsListItem({
                    prefixResource: item.symbolSrc,
                    title: item.textContent,
                    // prefixColor:$r('sys.color.icon_secondary'),
                    // subTitle:$r(''),
                    // desc:$r(''),
                    // badgeNum:
                    // buttonTitle:
                    // itemHeight:
                    handleClickAction: () => {
                      if (item.onclick) {
                        item.onclick();
                      } else {

                      }
                    },
                  })
                }
              }
            })
          }
          .backgroundColor($r('sys.color.comp_background_primary'))
          .borderRadius($r('sys.float.corner_radius_level8'))
          .padding($r('sys.float.padding_level2'))
        })
      }
      .padding({ left: CommonConstants.SPACE_12, right: CommonConstants.SPACE_12 })
      .margin({
        top: this.globalInfoModel.statusBarHeight + CommonConstants.NAVIGATION_HEIGHT,
        bottom: this.globalInfoModel.naviIndicatorHeight,
      })

    }
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    .align(Alignment.Top)
    .height('100%')
    .width('100%')
    .backgroundColor($r('sys.color.background_secondary'))
    .onDidScroll((xOffset: number, yOffset: number) => {
      this.viewModel.sendEvent<OffsetParam>({
        type: BaseHomeEventType.HANDLE_SCROLL_OFFSET,
        param: { yOffset: yOffset },
      });
    })

  }

  build() {
    HdsNavDestination() {
      this.mineContentViewBuilder()
    }
    .titleBar({
      avoidLayoutSafeArea: true,
      style: {
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.IMMERSIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE,
        },
        scrollEffectOpts: {
          scrollEffectType: ScrollEffectType.GRADIENT_BLUR,
          enableScrollEffect: true, // 开启滚动联动
        },
      }, // this.minePageState.topNavigationData.hdsTitleBarStyle
      content: {
        title: { mainTitle: $r('app.string.mine_title') },
      }
    })
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .hideBackButton(true)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
    .onReady((ctx: NavDestinationContext) => {
      const params: HomeContentParams = ctx.pathInfo.param as HomeContentParams;
      this.viewModel.sendEvent<InitializeParam>({
        type: BaseHomeEventType.INITIALIZE,
        param: {
          homeTabController: params.homeTabController,
          scroller: params.scroller
        }
      })
    })
    .onBackPressed(() => {
      return !!this.viewModel.sendEvent<null>({ type: BaseHomeEventType.ON_BACK_PRESS, param: null });
    })
  }
}


